# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/resolver"

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class FloatResolver < Resolver
        def process_value(value)
          return value if value.is_a?(Float)
          return value.to_f if value.respond_to?(:to_f)

          raise TypeMismatchError, "Flag value is not a float or convertable to one"
        rescue RangeError
          raise ParseError, "Flag value is not convertible to a float"
        end
      end
    end
  end
end
