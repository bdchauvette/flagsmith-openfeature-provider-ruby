# frozen_string_literal: true

require "open_feature/flagsmith/provider/error_resolution_creator"
require "open_feature/flagsmith/provider/flag_resolution_creator"
require "open_feature/flagsmith/provider/identity"

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class Resolver
        # @return [Flagsmith::Client]
        attr_reader :client

        # Mapping of exception classes to OpenFeature error codes.
        #
        # @return [Hash{StandardError => String}]
        attr_reader :error_mapping

        def initialize(client:, error_mapping:)
          @client = client
          @error_mapping = error_mapping
        end

        # Resolves a flag value by fetching it with the Flagsmith client and
        # converting it to an {SDK::Provider::ResolutionDetails} object.
        def resolve(flag_key:, default_value:, evaluation_context:)
          flag_collection = fetch_flag_collection(evaluation_context:)
          flag = flag_collection.get_flag(flag_key)
          result = process(flag)
          FlagResolutionCreator.call(flag_key:, flag:, value: result)
        rescue StandardError => e
          ErrorResolutionCreator.call(flag_key:, value: default_value, error_mapping:, error: e)
        end

        # Process the value returned by the Flagsmith client.
        #
        # This may be overridden by subclasses to cast the value to a more
        # specific type.
        def process_value(value)
          value
        end

        # Process the flag returned by the Flagsmith client.
        #
        # This may be overridden by subclasses to process the flag differently.
        def process(flag)
          process_value(flag.value)
        end

        private

        def fetch_flag_collection(evaluation_context:)
          if evaluation_context
            identity = Identity.from_context(evaluation_context)
            client.get_identity_flags(identity.identifier, **identity.traits)
          else
            client.get_environment_flags
          end
        end
      end
    end
  end
end
