# frozen_string_literal: true

module OpenFeature
  module Flagsmith
    class Provider
      class LiveFlagResolutionCreator
        def self.call(...)
          new(...).call
        end

        attr_reader :flag
        attr_reader :value

        def initialize(flag:, value:)
          @flag = flag
          @value = value
        end

        def call
          SDK::Provider::ResolutionDetails.new(
            value:,
            reason: SDK::Provider::Reason::UNKNOWN,
            variant: nil,
            flag_metadata: flag.to_h
          )
        end
      end
    end
  end
end
