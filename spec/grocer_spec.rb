require 'spec_helper'
require 'grocer'

describe Grocer do
  subject { described_class }

  describe '.env' do
    let(:environment) { nil }
    before do
      ENV.stubs(:[]).with('RAILS_ENV').returns(environment)
      ENV.stubs(:[]).with('RACK_ENV').returns(environment)
    end

    it 'defaults to development' do
      expect(subject.env).to eq('development')
    end

    it 'reads RAILS_ENV from ENV' do
      ENV.stubs(:[]).with('RAILS_ENV').returns('staging')
      expect(subject.env).to eq('staging')
    end

    it 'reads RACK_ENV from ENV' do
      ENV.stubs(:[]).with('RACK_ENV').returns('staging')
      expect(subject.env).to eq('staging')
    end
  end

  describe 'API facade' do
    let(:connection_options) { stub('connection options') }

    describe '.pusher' do
      before do
        Grocer::PushConnection.stubs(:new).returns(stub('PushConnection'))
      end

      it 'gets a Pusher' do
        expect(subject.pusher(connection_options)).to be_a Grocer::Pusher
      end

      it 'passes the connection options on to the underlying Connection' do
        subject.pusher(connection_options)
        expect(Grocer::PushConnection).to have_received(:new).with(connection_options)
      end
    end

    describe '.feedback' do
      before do
        Grocer::FeedbackConnection.stubs(:new).returns(stub('FeedbackConnection'))
      end

      it 'gets Feedback' do
        expect(subject.feedback(connection_options)).to be_a Grocer::Feedback
      end

      it 'passes the connection options on to the underlying Connection' do
        subject.feedback(connection_options)
        expect(Grocer::FeedbackConnection).to have_received(:new).with(connection_options)
      end
    end

    describe '.server' do
      let(:ssl_server) { stub_everything('SSLServer') }
      before do
        Grocer::SSLServer.stubs(:new).returns(ssl_server)
      end

      it 'gets Server' do
        expect(subject.server(connection_options)).to be_a Grocer::Server
      end

      it 'passes the connection options on to the underlying SSLServer' do
        subject.server(connection_options)
        expect(Grocer::SSLServer).to have_received(:new).with(connection_options)
      end
    end

  end
end
