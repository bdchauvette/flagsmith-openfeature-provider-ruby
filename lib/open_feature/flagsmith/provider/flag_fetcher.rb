# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/identity"

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class FlagFetcher
        # @param client [::Flagsmith::Client]
        def initialize(client:)
          @client = client
        end

        # Fetches a flag value from the Flagsmith client.
        def call(flag_key:, evaluation_context:)
          fetch_flag_set(evaluation_context:).get_flag(flag_key)
        end

        private

        # @return [::Flagsmith::Client]
        attr_reader :client

        def fetch_flag_set(evaluation_context:)
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
