require 'spec_helper'
require 'grocer/connection'

describe Grocer::Connection do
  subject { described_class.new(connection_options) }
  let(:connection_options) { { certificate: '/path/to/cert.pom' } }

  it 'is initialized with a certificate' do
    subject.certificate.should == connection_options[:certificate]
  end

  it 'defaults to an empty passphrase' do
    subject.passphrase.should be_nil
  end

  it 'is initialized with a passphrase' do
    connection_options[:passphrase] = 'new england clam chowder'
    subject.passphrase.should == connection_options[:passphrase]
  end

  it 'defaults to Apple push gateway' do
    subject.gateway.should == 'gateway.sandbox.push.apple.com'
  end

  it 'is initialized with a gateway' do
    connection_options[:gateway] = 'gateway.example.com'
    subject.gateway.should == connection_options[:gateway]
  end

  it 'defaults to 2195 as the port' do
    subject.port.should == 2195
  end

  it 'is initialized with a port' do
    connection_options[:port] = 443
    subject.port.should == connection_options[:port]
  end
end
