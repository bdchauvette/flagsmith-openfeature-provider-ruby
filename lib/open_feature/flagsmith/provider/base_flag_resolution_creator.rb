# frozen_string_literal: true

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class BaseFlagResolutionCreator
        def self.call(...)
          new(...).call
        end

        attr_reader :flag_key
        attr_reader :flag
        attr_reader :value

        def initialize(flag_key:, flag:, value:)
          @flag_key = flag_key
          @flag = flag
          @value = value
        end

        def call
          SDK::Provider::ResolutionDetails.new(
            value:,
            reason:,
            variant: nil,
            flag_metadata: {
              feature_name: flag_key,
              enabled: flag.enabled,
              default: flag.default
            }
          )
        end

        def reason
          if flag.default
            SDK::Provider::Reason::DEFAULT
          else
            SDK::Provider::Reason::UNKNOWN
          end
        end
      end
    end
  end
end
