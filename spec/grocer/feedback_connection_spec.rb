require 'spec_helper'
require 'grocer/feedback_connection'

describe Grocer::FeedbackConnection do
  subject { described_class.new(options) }
  let(:options) { { certificate: '/path/to/cert.pem' } }
  let(:connection) { stub('Connection') }

  it 'delegates reading to the Connection' do
    Grocer::Connection.any_instance.expects(:read).with(42, 'lolIO')
    subject.read(42, 'lolIO')
  end

  it 'delegates writing to the Connection' do
    Grocer::Connection.any_instance.expects(:write).with('Note Eye Fly')
    subject.write('Note Eye Fly')
  end

  it 'can be initialized with a certificate' do
    subject.certificate.should == '/path/to/cert.pem'
  end

  it 'can be initialized with a passphrase' do
    options[:passphrase] = 'open sesame'
    subject.passphrase.should == 'open sesame'
  end

  it 'defaults to Apple feedback gateway in production environment' do
    Grocer.stubs(:env).returns('production')
    subject.gateway.should == 'feedback.push.apple.com'
  end

  it 'defaults to the sandboxed Apple feedback gateway in development environment' do
    Grocer.stubs(:env).returns('development')
    subject.gateway.should == 'feedback.sandbox.push.apple.com'
  end

  it 'defaults to the sandboxed Apple feedback gateway in test environment' do
    Grocer.stubs(:env).returns('test')
    subject.gateway.should == 'feedback.sandbox.push.apple.com'
  end

  it 'defaults to the sandboxed Apple feedback gateway for other random values' do
    Grocer.stubs(:env).returns('random')
    subject.gateway.should == 'feedback.sandbox.push.apple.com'
  end

  it 'can be initialized with a gateway' do
    options[:gateway] = 'gateway.example.com'
    subject.gateway.should == 'gateway.example.com'
  end

  it 'defaults to 2196 as the port' do
    subject.port.should == 2196
  end

  it 'can be initialized with a port' do
    options[:port] = 443
    subject.port.should == 443
  end
end
