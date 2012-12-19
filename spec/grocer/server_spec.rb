require 'spec_helper'
require 'timeout'
require 'stringio'
require 'grocer/server'
require 'grocer/notification'

describe Grocer::Server do
  let(:ssl_server) { stub_everything }
  let(:mock_client) { StringIO.new }
  subject { described_class.new(ssl_server) }

  before do
    ssl_server.stubs(:accept).yields(mock_client)
    mock_client.stubs(:close)
  end

  after do
    subject.close
  end

  it "accepts client connections and reads notifications into a queue" do
    mock_client.write(Grocer::Notification.new(alert: "Hi!").to_bytes)
    mock_client.rewind

    subject.accept
    Timeout.timeout(5) {
      notification = subject.notifications.pop
      expect(notification.alert).to eq("Hi!")
    }
  end

  it "closes the socket" do
    ssl_server.expects(:close).at_least(1)

    subject.close
  end
end
