require 'spec_helper'

RSpec.describe RackDB do
  it 'reports a semantic version string' do
    expect( RackDB::VERSION ).to be_a( String )
    expect( /^(\d+\.\d+.\d+)$/ =~ RackDB::VERSION ).to eq( 0 ) # I.e. not "nil"
  end
end
