# encoding: UTF-8
require 'spec_helper'
require 'grocer/notification'
require 'grocer/shared_examples_for_notifications'

describe Grocer::Notification do
  
  MAX_ALERT_LENGTH = Grocer::Notification::MAX_PAYLOAD_SIZE - 20
  MAX_UTF_8_ALERT_LENGTH = MAX_ALERT_LENGTH / 2
  
  let(:payload_max_length_options) {{alert: 'a'*MAX_ALERT_LENGTH}}
  let(:payload_max_utf8_length_options) {{alert: 'à'*MAX_UTF_8_ALERT_LENGTH}}
  let(:payload_too_large_options) {{alert: 'a'*(MAX_ALERT_LENGTH+1)}}
  let(:payload_too_large_utf8_options) {{alert: 'à'*(MAX_UTF_8_ALERT_LENGTH+1)}}
  
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
    
    context 'ascii payload maximum length' do
      let(:payload_options) { payload_max_length_options }
      it 'encodes a 236 character payload' do
        expect(payload_dictionary_from_bytes[:aps][:alert]).to eq(notification.alert)      
      end      
    end

    context 'UTF-8 payload maximum length' do
      let(:payload_options) { payload_max_utf8_length_options}
      it 'encodes a 118 character payload' do
        expect(payload_dictionary_from_bytes[:aps][:alert]).to eq(notification.alert)      
      end      
    end
    
    context 'ascii payload too large' do
      let(:payload_options) {payload_too_large_options}
      
      it 'raises and error when the payload is too large' do
        -> { notification.to_bytes }.should raise_error(Grocer::PayloadTooLargeError)
      end
    end

    context 'UTF-8 payload too large'  do
      let(:payload_options) { payload_too_large_utf8_options }
      
      it 'raises and error when the payload is too large' do
        -> { notification.to_bytes }.should raise_error(Grocer::PayloadTooLargeError)
      end
    end    
  end
  
  describe "payload size" do
    let(:payload_options) { { alert: 'hi' } }
    include_examples 'a notification'
    
    context "ascii payload maximum legnth" do
      let(:payload_options) {payload_max_length_options}
      it "is valid" do
        notification.should_not be_payload_too_large
      end
    end
    context "ascii payload maximum legnth" do
      let(:payload_options) {payload_max_utf8_length_options}
      it "is valid" do
        notification.should_not be_payload_too_large
      end
    end
    context "ascii payload too large" do
      let(:payload_options) {payload_too_large_options}
      it "is invalid" do
        notification.should be_payload_too_large
      end
    end
    context "ascii payload to large" do
      let(:payload_options) {payload_too_large_utf8_options}
      it "is invalid" do
        notification.should be_payload_too_large
      end
    end
    
  end
  
end
