# frozen_string_literal: true

module OpenFeature
  module Flagsmith
    class Provider
      module ValueProcessors
        Boolean = lambda do |value|
          # We're leaving some performance on the table here by using an inline
          # array rather than using multiple comparisons or extracting the array
          # to a constant. In practice, this shouldn't matter too much for
          # performance, and hopefully MJIT, YJIT, and hardware branch
          # predictors can work some of their magic to make this "fast enough".
          return value if [true, false].include?(value)

          raise TypeMismatchError, "Flag value is not a boolean"
        end
      end
    end
  end
end
