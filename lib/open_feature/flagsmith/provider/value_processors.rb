# frozen_string_literal: true

require "open_feature/flagsmith/provider/value_processors/boolean"
require "open_feature/flagsmith/provider/value_processors/float"
require "open_feature/flagsmith/provider/value_processors/integer"
require "open_feature/flagsmith/provider/value_processors/number"
require "open_feature/flagsmith/provider/value_processors/object"
require "open_feature/flagsmith/provider/value_processors/string"

module OpenFeature
  module Flagsmith
    class Provider
      # Contains utilities for processing flag values.
      #
      # @api private
      module ValueProcessors
      end
    end
  end
end
