require 'spec_helper'
require 'grocer/push_connection_pool'

describe Grocer::PushConnectionPool do
  let(:connection) { stub('PushConnection') }

  subject(:connection_pool) { described_class.new({}) }

  before do
    connection_pool.stubs(:new_connection) { connections }
  end

  it 'creates a new connection when asked for one' do
    connection_pool.with_connection do |connection|
      # do nothing
    end

    connection_pool.should have_received(:new_connection)
  end
end
