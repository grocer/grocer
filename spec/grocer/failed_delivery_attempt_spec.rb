require 'spec_helper'
require 'grocer/failed_delivery_attempt'

describe Grocer::FailedDeliveryAttempt do
  let(:timestamp) { Time.utc(1995, 12, 21) }
  let(:device_token) { 'fe15a27d5df3c34778defb1f4f3980265cc52c0c047682223be59fb68500a9a2' }
  let(:binary_tuple) { [timestamp.to_i, 32, device_token].pack('NnH64') }
  let(:invalid_binary_tuple) { 'totally not the right format' }

  describe 'decoding' do
    it 'accepts a binary tuple and sets each attribute' do
      failed_delivery_attempt = described_class.new(binary_tuple)
      expect(failed_delivery_attempt.timestamp).to eq(timestamp)
      expect(failed_delivery_attempt.device_token).to eq(device_token)
    end

    it 'raises an exception when there are problems decoding' do
      -> { described_class.new(invalid_binary_tuple) }.should
        raise_error(Grocer::InvalidFormatError)
    end
  end
end
