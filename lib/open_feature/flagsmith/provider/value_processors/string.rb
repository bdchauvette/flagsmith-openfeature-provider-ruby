# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/resolver"

module OpenFeature
  module Flagsmith
    class Provider
      module ValueProcessors
        String = lambda do |_flag, value|
          return value if value.is_a?(::String)
          return value.to_str if value.respond_to?(:to_str)

          raise TypeMismatchError, "Flag value is not a string or an object that responds to #to_str"
        end
      end
    end
  end
end
