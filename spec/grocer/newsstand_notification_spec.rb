require 'spec_helper'
require 'grocer/newsstand_notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::NewsstandNotification do
  describe 'binary format' do
    let(:payload_options) { Hash.new }
    let(:payload) { payload_hash(notification) }

    include_examples 'a notification'

    it 'does require a payload' do
      expect(payload[:'content-available']).to_not be_nil
    end

    it 'has a content-available hash' do
      expect(payload[:'content-available']).to eq(1)
    end
  end
end
