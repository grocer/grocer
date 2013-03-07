require 'spec_helper'
require 'grocer/pusher'

describe Grocer::Pusher do
  let(:connection_pool) { stub('Grocer::PushConnectionPool') }
  let(:connection) { stub_everything }
  let(:notification) { stub(:to_bytes => 'abc123') }

  subject(:pusher) { described_class.new(connection_pool) }

  before do
    connection_pool.stubs(:with_connection).yields(connection)
  end

  describe '#push' do
    it 'serializes a notification and sends it via the connection' do
      pusher.push(notification)

      connection.should have_received(:write).with('abc123')
    end

    it 'checks out a connection before writing' do
      pusher.push(notification)

      connection_pool.should have_received(:with_connection)
    end
  end
end
