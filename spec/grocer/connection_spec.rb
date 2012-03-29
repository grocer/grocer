require "spec_helper"
require "grocer/connection"

describe Grocer::Connection do
  let(:connection_options) {
    {
      certificate: "/path/to/cert.pem",
      passphrase:  "abc123",
      gateway:     "gateway.push.highgroove.com",
      port:         1234
    }
  }

  subject { described_class.new(connection_options) }

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

