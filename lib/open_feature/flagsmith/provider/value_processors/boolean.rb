# frozen_string_literal: true

module OpenFeature
  module Flagsmith
    class Provider
      module ValueProcessors
        Boolean = lambda do |flag, value|
          # When a flag is first created, Flagsmith sets the value to nil, and
          # as long as the value is never changed through the UI, the value will
          # stay as nil. In this case, the flag's enabled status should be used
          # as the value of the flag.
          #
          # Note that in practice this particular code path SHOULD always return
          # `true`, because the resolver bails out early and uses a default
          # value if the flag is disabled. However, for the sake of correctness,
          # we should still explicitly check the flag's enabled status here.
          return flag.enabled? if value.nil?

          # Similarly, if a flag ever had a value, but it's then cleared, the
          # value of the flag will still be a string. When this happens, we want
          # to defer to the flag's enabled state, but only if the value is a
          # blank string, i.e. empty or whitespace-only. If the flag has any
          # non-whitespace characters, we should treat it as an invalid boolean
          # flag and end up raising an error.
          #
          # As with the nil case above, this check should only be reached if
          # the flag itself is enabled.
          return true if value.is_a?(::String) && value.strip.empty?

          # Otherwise, look at the flag value itself.
          #
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
