require 'spec_helper'
require 'open3'

RSpec.describe 'rackdb command' do
  it 'shows help' do
    output, status = Open3.capture2( 'ruby', File.join( File.dirname( __FILE__ ), '..', 'bin', 'rackdb' ), '-h' )
    expect( output.to_s.downcase ).to include( 'show this help message' )
  end

  it 'selects environment' do
    output, error, status = Dir.chdir( File.dirname( __FILE__ ) ) do
      Open3.capture3( 'ruby', File.join( '..', 'bin', 'rackdb' ), '-e', 'production' )
    end

    # Expect an error from the database adapter saying the 'production' database
    # is not present.
    #
    expect( error.to_s.downcase ).to include( 'example_production' )
  end
end
