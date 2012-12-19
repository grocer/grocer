# encoding: UTF-8

require 'spec_helper'
require 'grocer/notification'

describe Grocer::Notification do
  describe 'binary format' do
    let(:notification) { described_class.new(payload_options) }
    let(:payload_from_bytes) { notification.to_bytes[45..-1] }
    let(:payload_dictionary_from_bytes) { JSON.parse(payload_from_bytes, symbolize_names: true) }
    let(:payload_options) { { alert: 'hi', badge: 2, sound: 'siren.aiff' } }

    subject(:bytes) { notification.to_bytes }

    it 'sets the command byte to 1' do
      expect(bytes[0]).to eq("\x01")
    end

    it 'defaults the identifer to 0' do
      expect(bytes[1...5]).to eq("\x00\x00\x00\x00")
    end

    it 'allows the identifier to be set' do
      notification.identifier = 1234
      expect(bytes[1...5]).to eq([1234].pack('N'))
    end

    it 'defaults expiry to zero' do
      expect(bytes[5...9]).to eq("\x00\x00\x00\x00")
    end

    it 'allows the expiry to be set' do
      expiry = notification.expiry = Time.utc(2013, 3, 24, 12, 34, 56)
      expect(bytes[5...9]).to eq([expiry.to_i].pack('N'))
    end

    it 'encodes the device token length as 32' do
      expect(bytes[9...11]).to eq("\x00\x20")
    end

    it 'encodes the device token as a 256-bit integer' do
      token = notification.device_token = 'fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'
      expect(bytes[11...43]).to eq(['fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'].pack('H*'))
    end

    it 'as a convenience, flattens the device token to remove spaces' do
      token = notification.device_token = 'fe15 a27d 5df3c3 4778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'
      expect(bytes[11...43]).to eq(['fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'].pack('H*'))
    end

    it 'encodes the payload length' do
      notification.alert = 'Hello World!'
      expect(bytes[43...45]).to eq([payload_from_bytes.bytesize].pack('n'))
    end

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
  end
end
