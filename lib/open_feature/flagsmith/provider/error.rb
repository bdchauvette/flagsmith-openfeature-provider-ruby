# frozen_string_literal: true

require "open_feature/sdk/provider/error_code"

module OpenFeature
  module Flagsmith
    class Provider
      class Error < StandardError
        def open_feature_error_code
          SDK::Provider::ErrorCode::GENERAL
        end
      end

      class FlagNotFoundError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::FLAG_NOT_FOUND
        end
      end

      class InvalidContextError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::INVALID_CONTEXT
        end
      end

      class ParseError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::PARSE_ERROR
        end
      end

      class TargetingKeyMissingError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::TARGETING_KEY_MISSING
        end
      end

      class TypeMismatchError < Error
        def open_feature_error_code
          SDK::Provider::ErrorCode::TYPE_MISMATCH
        end
      end

      class UnsupportedTypeError < Error
        ERROR_CODE = "UNSUPPORTED_TYPE"

        def open_feature_error_code
          ERROR_CODE
        end
      end
    end
  end
end
