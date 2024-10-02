# frozen_string_literal: true

module OpenFeature
  module Flagsmith
    class Provider
      module ValueProcessors
        Integer = lambda do |_flag, value|
          return value if value.is_a?(::Integer)
          return value.to_int if value.respond_to?(:to_int)

          raise TypeMismatchError, "Flag value is not an integer or a value that responds to #to_int"
        rescue RangeError => e
          raise e, "Flag value is not convertible to an integer: #{e.message}"
        end
      end
    end
  end
end
