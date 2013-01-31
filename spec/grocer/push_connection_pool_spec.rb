require 'spec_helper'
require 'grocer/push_connection_pool'

describe Grocer::PushConnectionPool do
  subject { described_class.new(options) }
  let(:options)         { { certificate: '/path/to/cert.pem' } }
  let(:push_connection) { stub('PushConnection') }

  before do
    Grocer::PushConnection.stubs(:new).returns(push_connection)
    push_connection.stubs(:write)
  end

  it 'instantiates a PushConnection on write' do
    subject.write('abc')
    Grocer::PushConnection.should have_received(:new).with(options)
  end

  it 'delegates the write to the PushConnection' do
    push_connection.stubs(:write).returns(true)
    expect(subject.write('abc')).to be_true
  end
end
