require 'spec_helper'
require 'grocer/newsstand_notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::NewsstandNotification do
  describe 'binary format' do
    let(:payload_options) { Hash.new }
    let(:payload_dictionary_from_bytes) { JSON.parse(payload_from_bytes, symbolize_names: true) }
    let(:payload_from_bytes) { notification.to_bytes[45..-1] }

    include_examples 'a notification'

    it 'does require a payload' do
      expect(payload_dictionary_from_bytes[:aps]).to_not be_empty
    end

    it 'encodes content-available as part of the payload' do
      expect(payload_dictionary_from_bytes[:aps][:'content-available']).to eq(1)
    end

  end
end
