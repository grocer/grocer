# encoding: UTF-8
require 'spec_helper'
require 'grocer/notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::Notification do
  describe 'binary format' do
    let(:payload_options) { { alert: 'hi', badge: 2, sound: 'siren.aiff' } }
    let(:payload_dictionary_from_bytes) { JSON.parse(payload_from_bytes, symbolize_names: true) }
    let(:payload_from_bytes) { notification.to_bytes[45..-1] }

    include_examples 'a notification'

    it 'encodes alert as part of the payload' do
      notification.alert = 'Hello World!'
      expect(payload_dictionary_from_bytes[:aps][:alert]).to eq('Hello World!')
    end

    it 'encodes badge as part of the payload' do
      notification.badge = 42
      expect(payload_dictionary_from_bytes[:aps][:badge]).to eq(42)
    end

    it 'encodes sound as part of the payload' do
      notification.sound = 'siren.aiff'
      expect(payload_dictionary_from_bytes[:aps][:sound]).to eq('siren.aiff')
    end

    it 'encodes custom payload attributes' do
      notification.custom = { :foo => 'bar' }
      expect(payload_dictionary_from_bytes[:foo]).to eq('bar')
    end

    it 'encodes UTF-8 characters' do
      notification.alert = '私'
      expect(payload_dictionary_from_bytes[:aps][:alert].force_encoding("UTF-8")).to eq('私')
    end

    it 'encodes the payload length' do
      notification.alert = 'Hello World!'
      expect(bytes[43...45]).to eq([payload_from_bytes.bytesize].pack('n'))
    end

    it 'encodes the payload length correctly for multibyte UTF-8 strings' do
      notification.alert = '私'
      expect(bytes[43...45]).to eq([payload_from_bytes.bytesize].pack('n'))
    end

    context 'invalid payload' do
      let(:payload_options) { Hash.new }

      it 'raises an error when neither alert nor badge is specified' do
        -> { notification.to_bytes }.should raise_error(Grocer::NoPayloadError)
      end
    end
    
    # if you include anything else in the notification, the number of characters in your alert is reduced
    context 'valid ascii payload' do
      let(:payload_options) { {alert: 'a'*236}}
      it 'encodes a 236 character payload' do
        expect(payload_dictionary_from_bytes[:aps][:alert]).to eq(notification.alert)      
      end      
    end

    context 'valid UTF-8 payload' do
      let(:payload_options) { {alert: 'à'*118}}
      it 'encodes a 118 character payload' do
        expect(payload_dictionary_from_bytes[:aps][:alert]).to eq(notification.alert)      
      end      
    end
    
    context 'invalid payload' do
      let(:payload_options) {{ alert: 'a'*237 }}
      
      it 'raises and error when the payload is too large' do
        -> { notification.to_bytes }.should raise_error(Grocer::InvalidPayloadError)
      end
    end

    context 'invalid UTF-8 payload' do
      let(:payload_options) { {alert: 'à'*119} }
      
      it 'raises and error when the payload is too large' do
        -> { notification.to_bytes }.should raise_error(Grocer::InvalidPayloadError)
      end
    end
    
  end
end
