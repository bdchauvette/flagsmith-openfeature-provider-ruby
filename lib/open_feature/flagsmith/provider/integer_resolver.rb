# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/resolver"

module OpenFeature
  module Flagsmith
    class Provider
      # Resolver for integer flag values.
      #
      # Converts flag values to integers using {#.to_i} or {#.to_int} if available.
      #
      # @api private
      class IntegerResolver < Resolver
        def process_value(value)
          return value if value.is_a?(Integer)
          return value.to_i if value.respond_to?(:to_i)
          return value.to_int if value.respond_to?(:to_int)

          raise TypeMismatchError, "Flag value is not an integer or convertable to one"
        rescue RangeError
          raise ParseError, "Flag value is not convertible to an integer"
        end
      end
    end
  end
end
