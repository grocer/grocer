shared_examples 'a notification' do
    let(:notification) { described_class.new(payload_options) }

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
end
