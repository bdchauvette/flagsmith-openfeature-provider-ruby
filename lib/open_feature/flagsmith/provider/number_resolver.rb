# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/resolver"

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class NumberResolver < Resolver
        def resolve(flag_key:, default_value:, evaluation_context:)
          unless default_value.nil? || default_value.is_a?(Numeric)
            raise TypeMismatchError, "Default value must be a number or nil"
          end

          super
        end

        def process_value(value)
          raise TypeMismatchError, "Flag value is not numeric" unless value.is_a?(Numeric)

          value
        end
      end
    end
  end
end
