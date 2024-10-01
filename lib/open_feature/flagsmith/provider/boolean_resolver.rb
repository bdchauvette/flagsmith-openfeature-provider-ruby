# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/resolver"

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class BooleanResolver < Resolver
        def resolve(flag_key:, default_value:, evaluation_context:)
          unless default_value.nil? || [true, false].include?(default_value)
            raise TypeMismatchError, "Default value must be true, false, or nil"
          end

          super
        end

        def process(flag)
          flag.enabled?
        end

        def process_value(value)
          case value
          in true, false
            value
          else
            # Note that we don't try to convert the value to a boolean, because
            # everything in Ruby is truthy except for `nil` and `false`, so it
            # would be too easy to accidentally end up with an unexpected value.
            raise TypeMismatchError, "Flag value is not a boolean"
          end
        end
      end
    end
  end
end
