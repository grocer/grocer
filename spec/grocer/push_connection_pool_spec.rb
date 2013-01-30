require 'spec_helper'
require 'grocer/push_connection_pool'

describe Grocer::PushConnectionPool do
  subject { described_class.new(options) }
  let(:options)         { { certificate: '/path/to/cert.pem' } }
  let(:push_connection) { stub('PushConnection') }

  it 'instantiates a PushConnection on write' do
    push_connection.stubs(:write)
    Grocer::PushConnection.stubs(:new).with(options).returns(push_connection)
    subject.write('abc')
    Grocer::PushConnection.should have_received(:new).with(options)
  end

  it 'delegates the write to the PushConnection' do
    push_connection.expects(:write).returns(true)
    Grocer::PushConnection.stubs(:new).with(options).returns(push_connection)
    subject.write('abc').should == true
  end
end
