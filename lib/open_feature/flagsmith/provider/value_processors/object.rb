# frozen_string_literal: true

require "json"

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/resolver"

module OpenFeature
  module Flagsmith
    class Provider
      module ValueProcessors
        Object = lambda do |value|
          JSON.parse(value)
        rescue JSON::ParserError => e
          raise ParseError, "Flag value cannot be parsed as JSON: #{e.message}"
        end
      end
    end
  end
end
