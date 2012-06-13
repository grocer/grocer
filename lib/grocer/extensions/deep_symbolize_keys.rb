module Grocer
  module Extensions
    module DeepSymbolizeKeys

      def deep_symbolize_keys
        result = {}
        each do |key, value|
          result[(key.to_sym rescue key)] = value.is_a?(Hash) ?
            (value.extend DeepSymbolizeKeys).deep_symbolize_keys : value
        end
        result
      end

    end
  end
end
