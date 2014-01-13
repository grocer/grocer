require 'spec_helper'
require 'grocer/ssl_connection'

describe Grocer::SSLConnection do
  def stub_sockets
    TCPSocket.stubs(:new).returns(mock_socket)
    OpenSSL::SSL::SSLSocket.stubs(:new).returns(mock_ssl)
  end

  def stub_certificate
    example_data = File.read(File.dirname(__FILE__) + '/../fixtures/example.pem')
    File.stubs(:read).with(connection_options[:certificate]).returns(example_data)
  end

  let(:mock_socket) { stub_everything }
  let(:mock_ssl)    { stub_everything }

  let(:connection_options) {
    {
      certificate: '/path/to/cert.pem',
      passphrase:  'abc123',
      gateway:     'gateway.push.example.com',
      port:         1234
    }
  }

  describe 'configuration with pre-read certificate' do
    before do
      stub_certificate
    end

    subject {
      string_io = File.read(connection_options[:certificate])
      described_class.new(connection_options.merge(certificate: string_io))
    }

    it 'is initialized with a certificate IO' do
      expect(subject.certificate).to eq(File.read(connection_options[:certificate]))
    end
  end

  subject { described_class.new(connection_options) }

  describe 'configuration' do
    it 'is initialized with a certificate' do
      expect(subject.certificate).to eq(connection_options[:certificate])
    end

    it 'is initialized with a passphrase' do
      expect(subject.passphrase).to eq(connection_options[:passphrase])
    end

    it 'is initialized with a gateway' do
      expect(subject.gateway).to eq(connection_options[:gateway])
    end

    it 'is initialized with a port' do
      expect(subject.port).to eq(connection_options[:port])
    end
  end

  describe 'connecting' do
    before do
      stub_sockets
      stub_certificate
    end

    it 'sets up an socket connection' do
      subject.connect
      expect(TCPSocket).to have_received(:new).with(connection_options[:gateway],
                                                connection_options[:port])
    end

    it 'sets up an SSL connection' do
      subject.connect
      expect(OpenSSL::SSL::SSLSocket).to have_received(:new).with(mock_socket, anything)
    end
  end

  describe 'writing data' do
    before do
      stub_sockets
      stub_certificate
    end

    it 'writes data to the SSL connection' do
      subject.connect
      subject.write('abc123')

      expect(mock_ssl).to have_received(:write).with('abc123')
    end
  end

  describe 'reading data' do
    before do
      stub_sockets
      stub_certificate
    end

    it 'reads data from the SSL connection' do
      subject.connect
      subject.read(42)

      expect(mock_ssl).to have_received(:read).with(42)
    end
  end
end
