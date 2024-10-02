# frozen_string_literal: true

module OpenFeature
  module Flagsmith
    class Provider
      module ValueProcessors
        Float = lambda do |_flag, value|
          return value if value.is_a?(::Float)
          return value.to_f if value.is_a?(Numeric) && value.respond_to?(:to_f)

          raise TypeMismatchError, "Flag value is not a float or a numeric value that can be converted to a float"
        rescue RangeError => e
          raise e, "Flag value is not convertible to a float: #{e.message}"
        end
      end
    end
  end
end
