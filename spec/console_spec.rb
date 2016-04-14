require 'spec_helper'
require 'rackdb/console.rb'

# Limited coverage only of internal configuration methods on the whole.
#
# Things either completely, or almost completely unchanged from Railties 4.2.6
# and thus not tested, or only partially tested include:
#
#   ::start
#   #start
#   #initialize
#   #parse_arguments
#
RSpec.describe RackDB::Console do

  # Call to ensure global-constant-based tests in start/end with a clean slate
  # regardless of execution order.
  #
  def clear_all
    Object.send( :remove_const, :Application ) if defined?( Application )
    Object.send( :remove_const, :Service ) if defined?( Service )
    Rack.singleton_class.send( :remove_method, :root ) if Rack.respond_to?( :root )
    ENV.delete( 'RACK_ENV' )
  end

  before :each do
    clear_all()
    @console = described_class.new()
  end

  after :each do
    clear_all()
  end

  context '#environment' do
    it 'finds RACK_ENV' do
      ENV[ 'RACK_ENV' ] = 'foo'
      expect( @console.environment ).to eq( 'foo' )
    end

    it 'falls back if RACK_ENV is missing' do
      expect( @console.environment ).to eq( 'development' )
    end
  end

  context '#root' do
    context 'with Application' do
      before :each do
        module Application
          def self.root; 'app_root'; end
        end
      end

      it 'works' do
        expect( @console.send( :root ) ).to eq( 'app_root' )
      end
    end

    context 'with Rack' do
      before :each do
        module Rack
          def self.root; 'rack_root'; end
        end
      end

      it 'works' do
        expect( @console.send( :root ) ).to eq( 'rack_root' )
      end
    end

    context 'with Service.config' do
      before :each do
        module Service
          class Config
            def self.root; 'svc_root'; end
          end

          def self.config
            Config
          end
        end
      end

      it 'works' do
        expect( @console.send( :root ) ).to eq( 'svc_root' )
      end
    end

    context 'default' do
      it 'works' do
        expect( @console.send( :root ) ).to eq( '.' )
      end
    end
  end

  context '#configurations' do
    before :each do
      module Application
        def self.root; File.dirname( __FILE__ ); end
      end

      path           = File.join( Application.root(), 'config', 'database.yml' )
      erb_yaml_file  = File.read( path )
      pure_yaml_file = ERB.new( erb_yaml_file ).result

      @comparison_configurations = YAML.load( pure_yaml_file )
    end

    after :each do
      Object.send( :remove_const, :Application ) if defined?( Application )
    end

    it 'returns the canned configuration data' do
      configurations = @console.send( :configurations )

      expect( configurations ).to eq( @comparison_configurations )
    end

    context 'and #config' do
      it 'returns the expected no-environment-default configuration' do
        expect( @console.config() ).to eq( @comparison_configurations[ 'development' ] )
      end

      it 'returns the expected environment-defined configuration' do
        ENV[ 'RACK_ENV' ] = 'foo'
        expect( @console.config() ).to eq( @comparison_configurations[ 'foo' ] )
      end

      it 'complains about unknown environments' do
        ENV[ 'RACK_ENV' ] = 'unknown'
        expect {
          @console.config()
        }.to raise_error( ActiveRecord::AdapterNotSpecified, "'unknown' database is not configured. Available configuration: #{ @comparison_configurations.inspect }" )
      end
    end
  end

  context '#parse_arguments' do
    it 'should show help if asked' do
      expect {
        @console.send( :parse_arguments, [ '--help' ] )
      }.to output( Regexp.new( Regexp.quote( 'Show this help message.' ) ) ).to_stdout
    end

    it 'captures environment implicitly as a first parameter' do
      options = @console.send( :parse_arguments, [ 'test', '--header' ] )
      expect( options[ :environment ] ).to eq( 'test' )
    end

    it 'captures environment explicitly as a named parameter' do
      options = @console.send( :parse_arguments, [ '--environment', 'foo' ] )
      expect( options[ :environment ] ).to eq( 'foo' )
    end
  end
end
