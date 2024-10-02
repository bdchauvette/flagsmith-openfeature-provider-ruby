# frozen_string_literal: true

require "open_feature/sdk/provider/reason"
require "open_feature/sdk/provider/resolution_details"

require "open_feature/flagsmith/provider/refinements/error_refinements"

module OpenFeature
  module Flagsmith
    # @api private
    class Provider
      # Resolves flags by fetching them using the Flagsmith SDK and processing
      # the results to make sure they have the expected types.
      #
      # @api private
      class Resolver
        using Refinements::ErrorRefinements

        def initialize(flag_fetcher:)
          @flag_fetcher = flag_fetcher
        end

        # Resolves a flag.
        #
        # @note
        #   This method SHOULD never throw an exception. Instead, it strives to
        #   always return an instance of {SDK::Provider::ResolutionDetails},
        #   even in the face of unexpected errors.
        #
        # @param flag_key [String, Symbol]
        #   The name of the feature in Flagsmith.
        # @param default_value [Object]
        #   The default value to return if the flag is disabled or not found, or
        #   if there is an error while resolving the flag value.
        # @param evaluation_context [SDK::Provider::EvaluationContext]
        #   An object that provides context for flag evaluation.
        #
        # @yield [flag, flag_value] Gives the flag value to the block, if the flag is found AND enabled.
        # @yieldparam flag [::Flagsmith::Flags::Flag] The flag itself
        # @yieldparam flag_value [Object] The value of the flag
        # @yieldreturn [Object] The processed value of the flag
        #
        # @return [SDK::Provider::ResolutionDetails]
        def resolve(flag_key:, default_value:, evaluation_context:)
          flag = flag_fetcher.call(flag_key:, evaluation_context:)

          # If the flag is disabled, return the default value. Note that
          # although Flagsmith returns the value of the flag even if it is
          # disabled, we do not attempt to process the flag value unless it is
          # enabled. This is to prevent potential issues where a disabled flag
          # could affect live results by returning an error.
          return default_value_resolution_details(flag:, value: default_value) unless flag.enabled?

          # In addition to disabling flags through config, the Flagsmith SDK
          # also allows defining default flags using a fallback block for when
          # a flag cannot be retrieved from the API or a non-existent feature is
          # requested. In these cases, the block MAY return a special kind of
          # flag object {::Flagsmith::Flags::DefaultFlag} that is marked as a
          # default flag, but MAY differ from the default value provided to this
          # `resolve` method.
          #
          # If this happens, we still want to indicate that the flag's reason is
          # DEFAULT, but we want to use the value on the flag object.
          return default_value_resolution_details(flag:, value: flag.value) if flag.default

          # If we've made it here, then we're dealing with what the Flagsmith
          # SDK calls a "live" flag, which means it was successfully fetched
          # from the API or local evaluation. In this case, we want to process
          # the returned value using the given block, so that we can be sure
          # the found flag has the correct type.
          live_value_resolution_details(flag:, processed_value: yield(flag, flag.value))
        rescue StandardError => e
          # Capute any errors that occur during either flag fetching or value
          # processing, so that this method is guaranteed to always return an
          # instance of {SDK::Provider::ResolutionDetails}.
          #
          # This is in keeping with the philosophy of the OpenFeature SDK that
          # it should strive not to break application code, even in the face of
          # unexpected errors.
          error_resolution_details(error: e, default_value:)
        end

        private

        attr_reader :flag_fetcher

        def default_value_resolution_details(flag:, value:)
          SDK::Provider::ResolutionDetails.new(
            value:,
            reason: SDK::Provider::Reason::DEFAULT,
            variant: nil,
            flag_metadata: {
              enabled: flag.enabled?
            }
          )
        end

        def live_value_resolution_details(flag:, processed_value:)
          SDK::Provider::ResolutionDetails.new(
            value: processed_value,
            reason: SDK::Provider::Reason::UNKNOWN,
            variant: nil,
            flag_metadata: flag.respond_to?(:to_h) ? flag.to_h : {}
          )
        end

        def error_resolution_details(error:, default_value:)
          SDK::Provider::ResolutionDetails.new(
            value: default_value,
            reason: SDK::Provider::Reason::ERROR,
            variant: nil,
            error_code: error.open_feature_error_code,
            error_message: error.message,
            flag_metadata: {
              error_class: error.class.name,
              backtrace: error.backtrace.join("\n")
            }
          )
        end
      end
    end
  end
end
