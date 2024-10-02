# frozen_string_literal: true

require "open_feature/sdk/provider/error_code"
require "flagsmith/sdk/errors"
require "flagsmith/sdk/models/flags"

module OpenFeature
  module Flagsmith
    class Provider
      module Refinements
        # Refines various {Error} classes to add support for specific OpenFeature error codes.
        #
        # @see https://openfeature.dev/specification/types/#error-code
        module ErrorRefinements
          refine ::StandardError do
            def open_feature_error_code
              SDK::Provider::ErrorCode::GENERAL
            end
          end

          refine ::Flagsmith::Flags::NotFound do
            def open_feature_error_code
              SDK::Provider::ErrorCode::FLAG_NOT_FOUND
            end
          end

          refine ::Flagsmith::FeatureStateNotFound do
            def open_feature_error_code
              SDK::Provider::ErrorCode::FLAG_NOT_FOUND
            end
          end

          refine ::Flagsmith::ClientError do
            def open_feature_error_code
              SDK::Provider::ErrorCode::FLAGSMITH_CLIENT_ERROR
            end
          end

          refine ::Flagsmith::APIError do
            def open_feature_error_code
              SDK::Provider::ErrorCode::FLAGSMITH_API_ERROR
            end
          end
        end
      end
    end
  end
end
