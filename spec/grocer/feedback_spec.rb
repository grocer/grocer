require 'spec_helper'
require 'grocer/feedback'

describe Grocer::Feedback do
  def stub_feedback
    # "Reads" two failed deliveries: one on Jan 1; the other on Jan 2
    connection.stubs(:read).
               with(38).
               returns([jan1.to_i, 32, device_token].pack('NnH64')).
               then.
               returns([jan2.to_i, 32, device_token].pack('NnH64')).
               then.
               returns(nil)
  end

  let(:connection)   { stub_everything }
  let(:jan1)         { Time.utc(2012, 1, 1) }
  let(:jan2)         { Time.utc(2012, 1, 2) }
  let(:device_token) { 'fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2' }

  subject(:feedback) { described_class.new(connection) }

  it 'is enumerable' do
    expect(feedback).to be_kind_of(Enumerable)
  end

  it 'reads failed delivery attempt messages from the connection' do
    stub_feedback

    delivery_attempts = feedback.to_a

    expect(delivery_attempts[0].timestamp).to eq(jan1)
    expect(delivery_attempts[0].device_token).to eq(device_token)

    expect(delivery_attempts[1].timestamp).to eq(jan2)
    expect(delivery_attempts[1].device_token).to eq(device_token)
  end
end
