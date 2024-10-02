# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/resolver"

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class NumberResolver < Resolver
        def process_value(value)
          raise TypeMismatchError, "Flag value is not numeric" unless value.is_a?(Numeric)

          value
        end
      end
    end
  end
end
