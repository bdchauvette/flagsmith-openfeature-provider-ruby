# frozen_string_literal: true

require "flagsmith"
require "open_feature/sdk/provider"

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/version"

require "open_feature/flagsmith/provider/boolean_resolver"
require "open_feature/flagsmith/provider/float_resolver"
require "open_feature/flagsmith/provider/integer_resolver"
require "open_feature/flagsmith/provider/number_resolver"
require "open_feature/flagsmith/provider/string_resolver"

module OpenFeature
  module Flagsmith
    # @api private
    class Provider
      # Name of the provider to use in metadata.
      #
      # @see OpenFeature::SDK::Provider::ProviderMetadata
      PROVIDER_NAME = "Flagsmith Provider"

      # Default mapping of errors to error codes.
      #
      # @type [Hash{StandardError => String}]
      DEFAULT_ERROR_MAPPING = {
        ::Flagsmith::Flags::NotFound => SDK::Provider::ErrorCode::FLAG_NOT_FOUND,
        ::Flagsmith::ClientError => SDK::Provider::ErrorCode::PROVIDER_FATAL,
        ::Flagsmith::APIError => SDK::Provider::ErrorCode::PROVIDER_FATAL,
        ::Flagsmith::FeatureStateNotFound => SDK::Provider::ErrorCode::FLAG_NOT_FOUND
      }.freeze

      # Creates a {::Flagsmith::Client} using the given arguments and then
      # creates a new instance of {Provider} using that client.
      #
      # @return [Provider]
      def self.build(...)
        client = ::Flagsmith::Client.new(...)
        new(client:)
      end

      # Metadata about the provider.
      #
      # @return [OpenFeature::SDK::Provider::ProviderMetadata]
      attr_reader :metadata

      # The Flagsmith client used to fetch flags.
      #
      # @return [Flagsmith::Client]
      attr_reader :client

      # Mapping of error classes to OpenFeature error codes.
      #
      # @return [Hash{StandardError => String}]
      attr_reader :error_mapping

      def initialize(client:, error_mapping: DEFAULT_ERROR_MAPPING)
        @metadata = OpenFeature::SDK::Provider::ProviderMetadata.new(name: PROVIDER_NAME)
        @client = client
        @error_mapping = error_mapping
      end

      # Implements the {OpenFeature::SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol] The key of the flag to fetch.
      # @param default_value [Boolean, nil] The default value to return if the flag is not found.
      # @param evaluation_context [SDK::Provider::EvaluationContext] An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_boolean_value(flag_key:, default_value:, evaluation_context: nil)
        boolean_resolver.resolve(flag_key:, default_value:, evaluation_context:)
      end

      # Implements the {OpenFeature::SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol] The key of the flag to fetch.
      # @param default_value [String, nil] The default value to return if the flag is not found.
      # @param evaluation_context [SDK::Provider::EvaluationContext] An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_string_value(flag_key:, default_value:, evaluation_context: nil)
        string_resolver.resolve(flag_key:, default_value:, evaluation_context:)
      end

      # Implements the {OpenFeature::SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol] The key of the flag to fetch.
      # @param default_value [Numeric, nil] The default value to return if the flag is not found.
      # @param evaluation_context [SDK::Provider::EvaluationContext] An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_number_value(flag_key:, default_value:, evaluation_context: nil)
        number_resolver.resolve(flag_key:, default_value:, evaluation_context:)
      end

      # Implements the {OpenFeature::SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol] The key of the flag to fetch.
      # @param default_value [Integer, nil] The default value to return if the flag is not found.
      # @param evaluation_context [SDK::Provider::EvaluationContext] An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_integer_value(flag_key:, default_value:, evaluation_context: nil)
        integer_resolver.resolve(flag_key:, default_value:, evaluation_context:)
      end

      # Implements the {OpenFeature::SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol] The key of the flag to fetch.
      # @param default_value [Float, nil] The default value to return if the flag is not found.
      # @param evaluation_context [SDK::Provider::EvaluationContext] An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_float_value(flag_key:, default_value:, evaluation_context: nil)
        float_resolver.resolve(flag_key:, default_value:, evaluation_context:)
      end

      # Implements the {OpenFeature::SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @note
      #   This method always returns an error resolution, because at the time it
      #   was implemented, object values were not supported by the Flagsmith API.
      #
      #   To deal with structured data, you can serialize it to a string, fetch
      #   it with {#fetch_string_value}, and then parse it in your application.
      #
      # @param flag_key [String, Symbol] The key of the flag to fetch.
      # @param default_value [Object, nil] The default value to return if the flag is not found.
      # @param evaluation_context [SDK::Provider::EvaluationContext] An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_object_value(flag_key:, default_value:, evaluation_context: nil) # rubocop:disable Lint/UnusedMethodArgument
        SDK::Provider::ResolutionDetails.new(
          value: default_value,
          reason: SDK::Provider::Reason::ERROR,
          variant: nil,
          error_code: "UNSUPPORTED_TYPE",
          error_message: "Object value flags are not supported",
          flag_metadata: {
            feature_name: flag_key
          }
        )
      end

      private

      def boolean_resolver
        @boolean_resolver || BooleanResolver.new(client:, error_mapping:)
      end

      def string_resolver
        @string_resolver || StringResolver.new(client:, error_mapping:)
      end

      def number_resolver
        @number_resolver || NumberResolver.new(client:, error_mapping:)
      end

      def integer_resolver
        @integer_resolver || IntegerResolver.new(client:, error_mapping:)
      end

      def float_resolver
        @float_resolver || FloatResolver.new(client:, error_mapping:)
      end
    end
  end
end
