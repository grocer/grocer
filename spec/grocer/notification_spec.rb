# encoding: UTF-8
require 'spec_helper'
require 'grocer/notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::Notification do
  describe 'binary format' do
    let(:payload_options) { { alert: 'hi', badge: 2, sound: 'siren.aiff' } }
    let(:payload) { payload_hash(notification) }

    include_examples 'a notification'

    it 'encodes alert as part of the payload' do
      notification.alert = 'Hello World!'
      expect(payload[:aps][:alert]).to eq('Hello World!')
    end

    it 'encodes badge as part of the payload' do
      notification.badge = 42
      expect(payload[:aps][:badge]).to eq(42)
    end

    it 'encodes sound as part of the payload' do
      notification.sound = 'siren.aiff'
      expect(payload[:aps][:sound]).to eq('siren.aiff')
    end

    it 'encodes custom payload attributes' do
      notification.custom = { :foo => 'bar' }
      expect(payload[:foo]).to eq('bar')
    end

    it 'encodes UTF-8 characters' do
      notification.alert = '私'
      expect(payload[:aps][:alert].force_encoding("UTF-8")).to eq('私')
    end

    it 'encodes the payload length' do
      notification.alert = 'Hello World!'
      expect(bytes[43...45]).to eq([payload_bytes(notification).bytesize].pack('n'))
    end

    it 'encodes the payload length correctly for multibyte UTF-8 strings' do
      notification.alert = '私'
      expect(bytes[43...45]).to eq([payload_bytes(notification).bytesize].pack('n'))
    end

    it 'encodes content-available as part of the payload if a truthy value is passed' do
      notification.content_available = :foo
      expect(payload[:aps][:'content-available']).to eq(1)
    end

    it 'does not encode content-available as part of the payload if a falsy value is passed' do
      notification.content_available = false
      expect(payload[:aps]).to_not have_key(:'content-available')
    end

    it "is valid" do
      expect(notification.valid?).to be_true
    end

    context 'missing payload' do
      let(:payload_options) { Hash.new }

      it 'raises an error when none of alert, badge, or custom are specified' do
        -> { notification.to_bytes }.should raise_error(Grocer::NoPayloadError)
      end

      it 'is not valid' do
        expect(notification.valid?).to be_false
      end

      [{alert: 'hi'}, {badge: 1}, {custom: {a: 'b'}}].each do |payload|
        context "when #{payload.keys.first} exists, but not any other payload keys" do
          let(:payload_options) { payload }

          it 'does not raise an error' do
            -> { notification.to_bytes }.should_not raise_error
          end
        end
      end
    end

    context 'oversized payload' do
      let(:payload_options) { { alert: 'a' * (Grocer::Notification::MAX_PAYLOAD_SIZE + 1) } }

      it 'raises an error when the size of the payload in bytes is too large' do
        -> { notification.to_bytes }.should raise_error(Grocer::PayloadTooLargeError)
      end

      it 'is not valid' do
        expect(notification.valid?).to be_false
      end
    end
  end
end
