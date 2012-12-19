require 'spec_helper'
require 'grocer/ssl_server'

describe Grocer::SSLServer do
  subject { described_class.new(options) }
  let(:options) { { port: 12345 } }
  let(:mock_server) { stub_everything }
  let(:mock_ssl_server) { stub_everything }
  let(:mock_client) { stub_everything }

  before do
    TCPServer.stubs(:new).returns(mock_server)
    OpenSSL::SSL::SSLServer.stubs(:new).returns(mock_ssl_server)

    mock_ssl_server.stubs(:accept).returns(mock_client).then.returns(nil)
  end

  it "is constructed with a port option" do
    expect(subject.port).to eq(12345)
  end


  describe "#accept" do
    it "accepts client connections, yielding the client socket" do
      clients = []
      subject.accept { |c| clients << c }

      expect(clients).to eq([mock_client])
    end
  end

  describe "#close" do
    it "shutdowns the SSL socket" do
      mock_ssl_server.expects(:shutdown)

      # Emulate opening the socket
      subject.accept
      mock_ssl_server.stubs(:closed? => false)

      subject.close
    end

    it "ignores Errno::ENOTCONN errors that might be raised when shutting down the socket" do
      mock_ssl_server.stubs(:shutdown).raises(Errno::ENOTCONN)

      # Emulate opening the socket
      subject.accept
      mock_ssl_server.stubs(:closed? => false)

      subject.close
    end

    it "closes the SSL socket" do
      mock_ssl_server.expects(:close)

      # Emulate opening the socket
      subject.accept
      mock_ssl_server.stubs(:closed? => false)

      subject.close
    end

    it "is a no-op if the server has not been started" do
      mock_server.expects(:close).never
      mock_ssl_server.expects(:close).never

      subject.close
    end
  end
end
