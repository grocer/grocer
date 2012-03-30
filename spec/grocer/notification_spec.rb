require 'spec_helper'
require 'grocer/notification'

describe Grocer::Notification do
  describe 'binary format' do
    let(:notification) { described_class.new(payload_options) }
    let(:payload_from_bytes) { notification.to_bytes[45..-1] }
    let(:payload_dictionary_from_bytes) { JSON.parse(payload_from_bytes, symbolize_names: true) }
    let(:payload_options) { { alert: 'hi', badge: 2, sound: 'siren.aiff' } }

    subject { notification.to_bytes }

    it 'sets the command byte to 1' do
      subject[0].should == "\x01"
    end

    it 'defaults the identifer to 0' do
      subject[1...5].should == "\x00\x00\x00\x00"
    end

    it 'allows the identifier to be set' do
      notification.identifier = 1234
      subject[1...5].should == [1234].pack('N')
    end

    it 'defaults expiry to zero' do
      subject[5...9].should == "\x00\x00\x00\x00"
    end

    it 'allows the expiry to be set' do
      expiry = notification.expiry = Time.utc(2013, 3, 24, 12, 34, 56)
      subject[5...9].should == [expiry.to_i].pack('N')
    end

    it 'encodes the device token length as 32' do
      subject[9...11].should == "\x00\x20"
    end

    it 'encodes the device token as a 256-bit integer' do
      token = notification.device_token = 'fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'
      subject[11...43].should == ['fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'].pack('H*')
    end

    it 'as a convenience, flattens the device token to remove spaces' do
      token = notification.device_token = 'fe15 a27d 5df3c3 4778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'
      subject[11...43].should == ['fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2'].pack('H*')
    end

    it 'encodes the payload length' do
      notification.alert = 'Hello World!'
      subject[43...45].should == [payload_from_bytes.length].pack('n')
    end

    it 'encodes alert as part of the payload' do
      notification.alert = 'Hello World!'
      payload_dictionary_from_bytes[:aps][:alert].should == 'Hello World!'
    end

    it 'encodes badge as part of the payload' do
      notification.badge = 42
      payload_dictionary_from_bytes[:aps][:badge].should == 42
    end

    it 'encodes sound as part of the payload' do
      notification.sound = 'siren.aiff'
      payload_dictionary_from_bytes[:aps][:sound].should == 'siren.aiff'
    end

    it 'encodes custom payload attributes'

    context 'invalid payload' do
      let(:payload_options) { Hash.new }

      it 'raises an error when neither alert nor badge is specified' do
        -> { notification.to_bytes }.should raise_error(Grocer::NoPayloadError)
      end
    end
  end
end
