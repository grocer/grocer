require 'spec_helper'
require 'grocer/newsstand_notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::NewsstandNotification do
  describe 'binary format' do
    let(:payload_options) { Hash.new }
    let(:payload) { payload_hash(notification) }

    include_examples 'a notification'

    it 'requires a payload' do
      expect(payload[:aps]).to_not be_empty
    end

    it 'encodes content-available as part of the payload' do
      expect(payload[:aps][:'content-available']).to eq(1)
    end
  end
end
