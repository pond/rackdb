require 'spec_helper'
require 'open3'

RSpec.describe 'rackdb command' do
  def run_with( *args )
    Dir.chdir( File.dirname( __FILE__ ) ) do
      Open3.capture3( 'ruby', File.join( '..', 'bin', 'rackdb' ), *args )
    end
  end

  it 'shows help' do
    output, status = Open3.capture2( 'ruby', File.join( File.dirname( __FILE__ ), '..', 'bin', 'rackdb' ), '-h' )
    expect( output.to_s.downcase ).to include( 'show this help message' )
  end

  # Expect an error from the database adapter saying the 'production' database
  # is not present.
  #
  it 'selects environment' do
    output, error, status = run_with( '-e', 'production' )
    expect( error.to_s.downcase ).to include( 'example_production' )

    output, error, status = run_with( '--environment', 'production' )
    expect( error.to_s.downcase ).to include( 'example_production' )
  end

  # Should accept the option but then realise it doesn't know what database
  # adapter "example" yields.
  #
  it 'accepts password option' do
    output, error, status = run_with( '-p' )
    expect( error.to_s.downcase ).to include( 'unknown command-line client' )

    output, error, status = run_with( '--include-password' )
    expect( error.to_s.downcase ).to include( 'unknown command-line client' )
  end

  # As previous example.
  #
  it 'accepts valid modes' do
    output, error, status = run_with( '--mode', 'html' )
    expect( error.to_s.downcase ).to include( 'unknown command-line client' )
  end

  it 'rejects invalid modes' do
    output, error, status = run_with( '--mode', 'foo' )
    expect( error.to_s.downcase ).to include( 'invalid argument: --mode foo')
  end

end
