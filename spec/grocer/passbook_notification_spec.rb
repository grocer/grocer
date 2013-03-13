require 'spec_helper'
require 'grocer/passbook_notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::PassbookNotification do
  describe 'binary format' do
    let(:payload_options) { Hash.new }

    include_examples 'a notification'

    it 'does not require a payload' do
      expect(payload_hash(notification)[:aps]).to be_empty
    end

    it 'encodes the payload length' do
      payload_length = bytes[43...45].to_i
      expect(payload_length).to be_zero
    end

  end
end
