require 'spec_helper'
require 'grocer/mobile_device_management_notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::MobileDeviceManagementNotification do
  describe 'binary format' do
    let(:payload_options) { Hash[:push_magic, "00000000-1111-3333-4444-555555555555"] }
    let(:payload_from_bytes) { notification.to_bytes[45..-1] }
    let(:payload_dictionary_from_bytes) { JSON.parse(payload_from_bytes, symbolize_names: true) }

    include_examples 'a notification'

    it 'should have a single key in the payload' do
      expect(payload_dictionary_from_bytes.length).to eq(1)
    end

    it 'does require a mdm payload' do
      expect(payload_dictionary_from_bytes[:'mdm']).to_not be_nil
    end
  end
end
