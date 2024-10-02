# frozen_string_literal: true

module OpenFeature
  module Flagsmith
    class Provider
      module ValueProcessors
        Number = lambda do |value|
          return value if value.is_a?(Numeric)

          raise TypeMismatchError, "Flag value is not a number"
        end
      end
    end
  end
end
