require 'spec_helper'
require 'grocer/passbook_notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::PassbookNotification do
  describe 'binary format' do
    let(:payload_options) { Hash.new }
    let(:payload_dictionary_from_bytes) { JSON.parse(payload_from_bytes, symbolize_names: true) }
    let(:payload_from_bytes) { notification.to_bytes[45..-1] }

    include_examples 'a notification'

    it 'does not require a payload' do
      expect(payload_dictionary_from_bytes[:aps]).to be_empty
    end

    it 'encodes the payload length' do
      payload_length = bytes[43...45].to_i
      expect(payload_length).to be_zero
    end

  end
end
