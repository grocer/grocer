require 'spec_helper'
require 'grocer/connection'

describe Grocer::Connection do
  subject { described_class.new(connection_options) }
  let(:connection_options) { { certificate: '/path/to/cert.pem',
                               gateway: 'push.example.com',
                               port: 443 } }
  let(:ssl) { stub_everything('SSLConnection') }
  before do
    Grocer::SSLConnection.stubs(:new).returns(ssl)
  end

  it 'can be initialized with a certificate' do
    subject.certificate.should == '/path/to/cert.pem'
  end

  it 'defaults to an empty passphrase' do
    subject.passphrase.should be_nil
  end

  it 'can be initialized with a passphrase' do
    connection_options[:passphrase] = 'new england clam chowder'
    subject.passphrase.should == 'new england clam chowder'
  end

  it 'defaults to 3 retries' do
    subject.retries.should == 3
  end

  it 'can be initialized with a number of retries' do
    connection_options[:retries] = 2
    subject.retries.should == 2
  end

  it 'requires a gateway' do
    connection_options.delete(:gateway)
    -> { described_class.new(connection_options) }.should raise_error(Grocer::NoGatewayError)
  end

  it 'can be initialized with a gateway' do
    subject.gateway.should == 'push.example.com'
  end

  it 'requires a port' do
    connection_options.delete(:port)
    -> { described_class.new(connection_options) }.should raise_error(Grocer::NoPortError)
  end

  it 'can be initialized with a port' do
    subject.port.should == 443
  end

  it 'can open the connection to the apple push notification service' do
    subject.connect
    ssl.should have_received(:connect)
  end
  
  it 'raises CertificateExpiredError for OpenSSL::SSL::SSLError with /certificate expired/i message' do
    ssl.stubs(:write).raises(OpenSSL::SSL::SSLError.new('certificate expired'))
    -> {subject.write('abc123')}.should raise_error(Grocer::CertificateExpiredError)
  end

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

  describe 'retries' do
    [SocketError, Errno::EPIPE].each do |error|
      it "retries #read in the case of an #{error}" do
        ssl.stubs(:read).raises(error).then.returns(42)
        subject.read
      end

      it "retries #write in the case of an #{error}" do
        ssl.stubs(:write).raises(error).then.returns(42)
        subject.write('abc123')
      end

      it 'raises the error if none of the retries work' do
        connection_options[:retries] = 1
        ssl.stubs(:read).raises(error).then.raises(error)
        -> { subject.read }.should raise_error(error)
      end
    end
  end
end
