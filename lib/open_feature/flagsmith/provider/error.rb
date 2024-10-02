# frozen_string_literal: true

require "open_feature/sdk/provider/error_code"

module OpenFeature
  module Flagsmith
    class Provider
      # Base class for all errors specific to this gem.
      class Error < StandardError
        def open_feature_error_code
          SDK::Provider::ErrorCode::GENERAL
        end
      end

      # Indicates that the client was unable to find the requested flag.
      #
      # @see https://openfeature.dev/specification/types/#error-code
      class FlagNotFoundError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::FLAG_NOT_FOUND
        end
      end

      # Indicates that the client was unable to evaluate the flag due to an
      # invalid evaluation context.
      #
      # @see https://openfeature.dev/specification/types/#error-code
      class InvalidContextError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::INVALID_CONTEXT
        end
      end

      # Indicates that the client was unable to parse the flag value.
      #
      # @see https://openfeature.dev/specification/types/#error-code
      class ParseError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::PARSE_ERROR
        end
      end

      # Indicates that a targeting key is missing from the evaluation context.
      #
      # @see https://openfeature.dev/specification/types/#error-code
      class TargetingKeyMissingError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::TARGETING_KEY_MISSING
        end
      end

      # Indicates that a flag value is not of the expected type.
      #
      # @see https://openfeature.dev/specification/types/#error-code
      class TypeMismatchError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::TYPE_MISMATCH
        end
      end
    end
  end
end
