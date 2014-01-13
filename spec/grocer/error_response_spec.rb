require_relative '../../lib/grocer/error_response'

describe Grocer::ErrorResponse do
  let(:status_code) { 1 }
  let(:identifier) { 8342 }
  let(:binary_tuple) { [described_class::COMMAND, status_code, identifier].pack('CCN') }
  let(:invalid_binary_tuple) { 'short' }

  subject(:error_response) { described_class.new(binary_tuple) }

  describe 'decoding' do
    it 'accepts a binary tuple and sets each attribute' do
      expect(error_response.status_code).to eq(status_code)
      expect(error_response.identifier).to eq(identifier)
    end

    it 'raises an exception when there are problems decoding' do
      expect { described_class.new(invalid_binary_tuple) }.to raise_error(Grocer::InvalidFormatError)
    end
  end

  it 'finds the status from the status code' do
    expect(error_response.status).to eq('Processing error')
  end
end
