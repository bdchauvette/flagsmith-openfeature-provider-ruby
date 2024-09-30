# frozen_string_literal: true

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class ErrorResolutionCreator
        def self.call(...)
          new(...).call
        end

        attr_reader :flag_key
        attr_reader :value
        attr_reader :error_mapping
        attr_reader :error

        def initialize(flag_key:, value:, error_mapping:, error:)
          @flag_key = flag_key
          @value = value
          @error_mapping = error_mapping
          @error = error
        end

        def call
          SDK::Provider::ResolutionDetails.new(
            value:,
            reason: SDK::Provider::Reason::ERROR,
            variant: nil,
            error_code:,
            error_message: error.message,
            flag_metadata: {
              feature_name: flag_key,
              error_class: error.class.name
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

        def error_code
          error_mapping.fetch(error.class) { SDK::Provider::ErrorCode::GENERAL }
        end
      end
    end
  end
end
