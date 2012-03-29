require "spec_helper"
require "grocer/ssl_connection"

describe Grocer::SSLConnection do
  def stub_sockets
    TCPSocket.stubs(:new).returns(mock_socket)
    OpenSSL::SSL::SSLSocket.stubs(:new).returns(mock_ssl)
  end

  def stub_certificate
    example_data = File.read(File.dirname(__FILE__) + "/../fixtures/example.pem")
    File.stubs(:read).with(connection_options[:certificate]).returns(example_data)
  end

  let(:mock_socket) { stub_everything }
  let(:mock_ssl)    { stub_everything }

  let(:connection_options) {
    {
      certificate: "/path/to/cert.pem",
      passphrase:  "abc123",
      gateway:     "gateway.push.highgroove.com",
      port:         1234
    }
  }

  subject { described_class.new(connection_options) }

  describe "configuration" do
    it "is initialized with a certificate" do
      subject.certificate.should == connection_options[:certificate]
    end

    it "is initialized with a passphrase" do
      subject.passphrase.should == connection_options[:passphrase]
    end

    it "is initialized with a gateway" do
      subject.gateway.should == connection_options[:gateway]
    end

    it "is initialized with a port" do
      subject.port.should == connection_options[:port]
    end
  end

  describe "connecting" do
    before do
      stub_sockets
      stub_certificate
    end

    it "sets up an socket connection" do
      subject.connect!
      TCPSocket.should have_received(:new).with(connection_options[:gateway],
                                                connection_options[:port])
    end

    it "sets up an SSL connection" do
      subject.connect!
      OpenSSL::SSL::SSLSocket.should have_received(:new).with(mock_socket, anything)
    end
  end

  describe "writing data" do
    before do
      stub_sockets
      stub_certificate
    end

    it "writes data to the SSL connection" do
      subject.connect!
      subject.write("abc123")

      mock_ssl.should have_received(:write).with("abc123")
    end
  end
end

