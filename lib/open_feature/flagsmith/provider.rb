# frozen_string_literal: true

require "flagsmith"
require "open_feature/sdk/provider"

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/error_code"
require "open_feature/flagsmith/provider/flag_fetcher"
require "open_feature/flagsmith/provider/reason"
require "open_feature/flagsmith/provider/resolver"
require "open_feature/flagsmith/provider/value_processors"
require "open_feature/flagsmith/provider/version"

module OpenFeature
  module Flagsmith
    # @api private
    class Provider
      # Name of the provider to use in metadata.
      #
      # @see SDK::Provider::ProviderMetadata
      PROVIDER_NAME = "Flagsmith Provider"

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
      # @return [SDK::Provider::ProviderMetadata]
      attr_reader :metadata

      def initialize(client:)
        @metadata = SDK::Provider::ProviderMetadata.new(name: PROVIDER_NAME)
        @resolver = Resolver.new(flag_fetcher: FlagFetcher.new(client:))
      end

      # Implements the {SDK::Provider} duck.
      def init; end

      # Implements the {SDK::Provider} duck.
      def shutdown; end

      # Implements the {SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol]
      #   The name of the feature in Flagsmith.
      # @param default_value [Boolean]
      #   The default value to return if the flag is disabled or not found, or
      #   if there is an error while resolving the flag value.
      # @param evaluation_context [SDK::Provider::EvaluationContext]
      #   An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_boolean_value(flag_key:, default_value:, evaluation_context: nil)
        resolve(flag_key:, default_value:, evaluation_context:, &ValueProcessors::Boolean)
      end

      # Implements the {SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol]
      #   The name of the feature in Flagsmith.
      # @param default_value [String]
      #   The default value to return if the flag is disabled or not found, or
      #   if there is an error while resolving the flag value.
      # @param evaluation_context [SDK::Provider::EvaluationContext]
      #   An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_string_value(flag_key:, default_value:, evaluation_context: nil)
        resolve(flag_key:, default_value:, evaluation_context:, &ValueProcessors::String)
      end

      # Implements the {SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol]
      #   The name of the feature in Flagsmith.
      # @param default_value [Numeric]
      #   The default value to return if the flag is disabled or not found, or
      #   if there is an error while resolving the flag value.
      # @param evaluation_context [SDK::Provider::EvaluationContext]
      #   An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_number_value(flag_key:, default_value:, evaluation_context: nil)
        resolve(flag_key:, default_value:, evaluation_context:, &ValueProcessors::Number)
      end

      # Implements the {SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol]
      #   The name of the feature in Flagsmith.
      # @param default_value [Integer]
      #   The default value to return if the flag is disabled or not found, or
      #   if there is an error while resolving the flag value.
      # @param evaluation_context [SDK::Provider::EvaluationContext]
      #   An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_integer_value(flag_key:, default_value:, evaluation_context: nil)
        resolve(flag_key:, default_value:, evaluation_context:, &ValueProcessors::Integer)
      end

      # Implements the {SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol]
      #   The name of the feature in Flagsmith.
      # @param default_value [Float]
      #   The default value to return if the flag is disabled or not found, or
      #   if there is an error while resolving the flag value.
      # @param evaluation_context [SDK::Provider::EvaluationContext]
      #   An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_float_value(flag_key:, default_value:, evaluation_context: nil)
        resolve(flag_key:, default_value:, evaluation_context:, &ValueProcessors::Float)
      end

      # Implements the {SDK::Provider} duck.
      #
      # @see https://github.com/open-feature/ruby-sdk/tree/main?tab=readme-ov-file#develop-a-provider
      #
      # @param flag_key [String, Symbol]
      #   The name of the feature in Flagsmith.
      # @param default_value [Float]
      #   The default value to return if the flag is disabled or not found, or
      #   if there is an error while resolving the flag value.
      # @param evaluation_context [SDK::Provider::EvaluationContext]
      #   An object that provides context for flag evaluation.
      # @return [SDK::Provider::ResolutionDetails]
      def fetch_object_value(flag_key:, default_value:, evaluation_context: nil)
        resolve(flag_key:, default_value:, evaluation_context:, &ValueProcessors::Object)
      end

      private

      # @return [Resolver]
      attr_reader :resolver

      def resolve(flag_key:, default_value:, evaluation_context:, &)
        resolver.resolve(flag_key:, default_value:, evaluation_context:, &)
      end
    end
  end
end
