require 'spec_helper'
require_relative '../../lib/grocer/error_response_checker'

describe Grocer::ErrorResponseChecker do
  let(:handler) { stub('Proc', arity: 1) }
  let(:invalid_handler) { stub('Proc', arity: 0) }

  subject(:error_response_checker) { described_class.new(handler) }

  it 'accepts a handler' do
    expect(error_response_checker.handler).to eq(handler)
  end

  it 'raises an exception when the handler does not accept a parameter' do
    expect { described_class.new(invalid_handler) }.to raise_error(Grocer::InvalidErrorResponseHandler)
  end

  describe '.check_for_responses' do
    let(:binary_tuple) { [Grocer::ErrorResponse::COMMAND, 1, 8342].pack('CCN') }
    let(:connection) { stub('Connection', read: binary_tuple) }
    let(:error_response) { stub('ErrorResponse') }

    before do
      Grocer::ErrorResponse.stubs(:new).with(binary_tuple).returns(error_response)
      handler.stubs(:call).with(error_response)
    end

    it 'reads from the connection' do
      error_response_checker.check_for_responses(connection)
      expect(connection).to have_received(:read).with(Grocer::ErrorResponse::LENGTH)
    end

    it 'parses the error response' do
      error_response_checker.check_for_responses(connection)
      expect(Grocer::ErrorResponse).to have_received(:new).with(binary_tuple)
    end

    it 'calls the handler with the parsed error response' do
      error_response_checker.check_for_responses(connection)
      expect(handler).to have_received(:call).with(error_response)
    end
  end
end
