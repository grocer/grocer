require 'spec_helper'
require 'grocer/connection'

describe Grocer::Connection do
  subject { described_class.new(connection_options) }
  let(:connection_options) { { certificate: '/path/to/cert.pom',
                               password: 'new england clam chowder',
                               gateway: 'push.example.com',
                               port: 443 } }
  let(:ssl) { stub_everything('SSLConnection') }
  before do
    Grocer::SSLConnection.stubs(:new).returns(ssl)
  end

  it 'requires a certificate' do
    connection_options.delete(:certificate)
    -> { described_class.new(connection_options) }.should raise_error(Grocer::NoCertificateErrror)
  end

  it 'can be initialized with a certificate' do
    subject.certificate.should == connection_options[:certificate]
  end

  it 'defaults to an empty passphrase' do
    connection_options.delete(:passphrase)
    subject.passphrase.should be_nil
  end

  it 'can be initialized with a passphrase' do
    subject.passphrase.should == connection_options[:passphrase]
  end

  it 'requires a gateway' do
    connection_options.delete(:gateway)
    -> { described_class.new(connection_options) }.should raise_error(Grocer::NoGatewayErrror)
  end

  it 'can be initialized with a gateway' do
    subject.gateway.should == connection_options[:gateway]
  end

  it 'requires a port' do
    connection_options.delete(:port)
    -> { described_class.new(connection_options) }.should raise_error(Grocer::NoPortError)
  end

  it 'can be initialized with a port' do
    subject.port.should == connection_options[:port]
  end

#  it 'defaults to Apple push gateway in production environment' do
#    Grocer.stubs(:env).returns('production')
#    subject.gateway.should == 'gateway.push.apple.com'
#  end
#
#  it 'defaults to the sandboxed Apple push gateway in development environment' do
#    Grocer.stubs(:env).returns('development')
#    subject.gateway.should == 'gateway.sandbox.push.apple.com'
#  end
#
#  it 'defaults to the sandboxed Apple push gateway in test environment' do
#    Grocer.stubs(:env).returns('test')
#    subject.gateway.should == 'gateway.sandbox.push.apple.com'
#  end
#
#  it 'defaults to the sandboxed Apple push gateway for other random values' do
#    Grocer.stubs(:env).returns('random')
#    subject.gateway.should == 'gateway.sandbox.push.apple.com'
#  end

#  it 'defaults to 2195 as the port' do
#    subject.port.should == 2195
#  end

  context 'an open SSLConnection' do
    before do
      ssl.stubs(:connected?).returns(true)
    end

    it '#write delegates to open SSLConnection' do
      subject.write('Apples to Oranges')
      ssl.should have_received(:write).with('Apples to Oranges')
    end

    it '#read delegates to open SSLConnection' do
      subject.read(42, 'IO')
      ssl.should have_received(:read).with(42, 'IO')
    end
  end

  context 'a closed SSLConnection' do
    before do
      ssl.stubs(:connected?).returns(false)
    end

    it '#write connects SSLConnection and delegates to it' do
      subject.write('Apples to Oranges')
      ssl.should have_received(:connect)
      ssl.should have_received(:write).with('Apples to Oranges')
    end

    it '#read connects SSLConnection delegates to open SSLConnection' do
      subject.read(42, 'IO')
      ssl.should have_received(:connect)
      ssl.should have_received(:read).with(42, 'IO')
    end
  end
end
