# frozen_string_literal: true

require "open_feature/flagsmith/provider/live_flag_resolution_creator"
require "open_feature/flagsmith/provider/base_flag_resolution_creator"

module OpenFeature
  module Flagsmith
    class Provider
      # Creates an {SDK::Provider::ResolutionDetails} object based on a
      # Flagsmith flag object.
      #
      # @see ::Flagsmith::Flags::BaseFlag
      # @see ::Flagsmith::Flags::DefaultFlag
      # @see ::Flagsmith::Flags::Flag
      #
      # @api private
      FlagResolutionCreator = lambda do |flag_key:, flag:, value:|
        if flag.respond_to?(:feature_id)
          LiveFlagResolutionCreator.call(flag:, value:)
        else
          BaseFlagResolutionCreator.call(flag_key:, flag:, value:)
        end
      end
    end
  end
end
