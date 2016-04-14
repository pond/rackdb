require 'erb'
require 'yaml'
require 'optparse'
require 'rbconfig'
require 'active_record'

module Service
  include ActiveSupport::Configurable
end

module RackDB
  class Console
    attr_reader :arguments

    def self.start
      new.start
    end

    def initialize(arguments = ARGV)
      @arguments = arguments
    end

    def start
      options = parse_arguments(arguments)
      exit if options.nil?

      ENV['RACK_ENV'] = options[:environment] || environment()
      Service.config.env = environment()

      case config["adapter"]
      when /^(jdbc)?mysql/
        args = {
          'host'      => '--host',
          'port'      => '--port',
          'socket'    => '--socket',
          'username'  => '--user',
          'encoding'  => '--default-character-set',
          'sslca'     => '--ssl-ca',
          'sslcert'   => '--ssl-cert',
          'sslcapath' => '--ssl-capath',
          'sslcipher' => '--ssl-cipher',
          'sslkey'    => '--ssl-key'
        }.map { |opt, arg| "#{arg}=#{config[opt]}" if config[opt] }.compact

        if config['password'] && options['include_password']
          args << "--password=#{config['password']}"
        elsif config['password'] && !config['password'].to_s.empty?
          args << "-p"
        end

        args << config['database']

        find_cmd_and_exec(['mysql', 'mysql5'], *args)

      when /^postgres|^postgis/
        ENV['PGUSER']     = config["username"] if config["username"]
        ENV['PGHOST']     = config["host"] if config["host"]
        ENV['PGPORT']     = config["port"].to_s if config["port"]
        ENV['PGPASSWORD'] = config["password"].to_s if config["password"] && options['include_password']
        find_cmd_and_exec('psql', config["database"])

      when "sqlite"
        find_cmd_and_exec('sqlite', config["database"])

      when "sqlite3"
        args = []

        args << "-#{options['mode']}" if options['mode']
        args << "-header" if options['header']
        args << File.expand_path(config['database'], root())

        find_cmd_and_exec('sqlite3', *args)

      when "oracle", "oracle_enhanced"
        logon = ""

        if config['username']
          logon = config['username']
          logon << "/#{config['password']}" if config['password'] && options['include_password']
          logon << "@#{config['database']}" if config['database']
        end

        find_cmd_and_exec('sqlplus', logon)

      when "sqlserver"
        args = []

        args += ["-D", "#{config['database']}"] if config['database']
        args += ["-U", "#{config['username']}"] if config['username']
        args += ["-P", "#{config['password']}"] if config['password']

        if config['host']
          host_arg = "#{config['host']}"
          host_arg << ":#{config['port']}" if config['port']
          args += ["-S", host_arg]
        end

        find_cmd_and_exec("sqsh", *args)

      else
        abort "Unknown command-line client for #{config['database']}."
      end
    end

    def config
      @config ||= begin
        if configurations()[environment].blank?
          raise ActiveRecord::AdapterNotSpecified, "'#{environment}' database is not configured. Available configuration: #{configurations().inspect}"
        else
          configurations()[environment]
        end
      end
    end

    def environment
      ENV["RACK_ENV"] || "development"
    end

    protected

    def root
      if defined?( Application ) && Application.respond_to?( :root )
        Application.root # Rails-like
      elsif Rack.respond_to?( :root )
        Rack.root # Hypothetical
      elsif defined?( Service ) && Service.respond_to?( :config ) && Service.config.respond_to?( :root ) && Service.config.root != nil
        Service.config.root # Hoodoo service
      else
        '.'
      end
    end

    def configurations
      ActiveRecord::Base.default_timezone = :utc

      path           = File.join( root(), 'config', 'database.yml' )
      erb_yaml_file  = File.read( path )
      pure_yaml_file = ERB.new( erb_yaml_file ).result

      ActiveRecord::Base.configurations = YAML.load( pure_yaml_file )
      return ActiveRecord::Base.configurations
    end

    def parse_arguments(arguments)
      options = {}

      OptionParser.new do |opt|
        opt.banner = "Usage: rackdb [environment] [options]"
        opt.on("-p", "--include-password", "Automatically provide the password from database.yml") do |v|
          options['include_password'] = true
        end

        opt.on("--mode [MODE]", ['html', 'list', 'line', 'column'],
          "Automatically put the sqlite3 database in the specified mode (html, list, line, column).") do |mode|
            options['mode'] = mode
        end

        opt.on("--header", "Turn on sqlite3 database command line header display.") do |h|
          options['header'] = h
        end

        opt.on("-h", "--help", "Show this help message.") do
          puts opt
          return nil
        end

        opt.on("-e", "--environment=name", String,
          "Specifies the environment to run this console under (test/development/production).",
          "Default: development"
        ) { |v| options[:environment] = v.strip }

        opt.parse!(arguments)
        abort opt.to_s unless (0..1).include?(arguments.size)
      end

      if arguments.first && arguments.first[0] != '-'
        options[:environment] = arguments.first
      end

      options
    end

    def find_cmd_and_exec(commands, *args)
      commands = Array(commands)

      dirs_on_path = ENV['PATH'].to_s.split(File::PATH_SEPARATOR)
      commands += commands.map{|cmd| "#{cmd}.exe"} if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/

      full_path_command = nil
      found = commands.detect do |cmd|
        dirs_on_path.detect do |path|
          full_path_command = File.join(path, cmd)
          File.executable? full_path_command
        end
      end

      if found
        exec full_path_command, *args
      else
        abort("Couldn't find database client: #{commands.join(', ')}. Check your $PATH and try again.")
      end
    end
  end
end
