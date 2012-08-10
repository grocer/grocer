module Grocer
  module Extensions
    module DeepSymbolizeKeys

      def deep_symbolize_keys
        result = {}
        each do |key, value|
          # Workaround for JRuby defining Fixnum#to_sym even in 1.9 mode
          symbolized_key = key.is_a?(Fixnum) ? key : (key.to_sym rescue key)

          result[symbolized_key] = value.is_a?(Hash) ?
            (value.extend DeepSymbolizeKeys).deep_symbolize_keys : value
        end
        result
      end

    end
  end
end
