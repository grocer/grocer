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
      subject.env.should == 'development'
    end

    it 'reads RAILS_ENV from ENV' do
      ENV.stubs(:[]).with('RAILS_ENV').returns('staging')
      subject.env.should == 'staging'
    end

    it 'reads RACK_ENV from ENV' do
      ENV.stubs(:[]).with('RACK_ENV').returns('staging')
      subject.env.should == 'staging'
    end
  end

  describe 'API facade' do
    let(:connection_options) { stub('connection options') }

    describe '.pusher' do
      before do
        Grocer::PushConnection.stubs(:new).returns(stub('PushConnection'))
      end

      it 'gets a Pusher' do
        subject.pusher(connection_options).should be_a Grocer::Pusher
      end

      it 'passes the connection options on to the underlying Connection' do
        subject.pusher(connection_options)
        Grocer::PushConnection.should have_received(:new).with(connection_options)
      end
    end

    describe '.feedback' do
      before do
        Grocer::FeedbackConnection.stubs(:new).returns(stub('FeedbackConnection'))
      end

      it 'gets Feedback' do
        subject.feedback(connection_options).should be_a Grocer::Feedback
      end

      it 'passes the connection options on to the underlying Connection' do
        subject.feedback(connection_options)
        Grocer::FeedbackConnection.should have_received(:new).with(connection_options)
      end
    end

  end

end
