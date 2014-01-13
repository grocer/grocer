require 'spec_helper'
require 'grocer/pusher'

describe Grocer::Pusher do
  let(:connection) { stub_everything }

  subject { described_class.new(connection) }

  describe '#push' do
    it 'serializes a notification and sends it via the connection' do
      notification = stub(:to_bytes => 'abc123')
      subject.push(notification)

      expect(connection).to have_received(:write).with('abc123')
    end
  end
end
