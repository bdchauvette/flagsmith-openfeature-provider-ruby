# frozen_string_literal: true

require "test_helper"

module OpenFeature
  module Flagsmith
    class TestProvider < Minitest::Test
      def test_that_it_has_a_version_number
        refute_nil ::OpenFeature::Flagsmith::Provider::VERSION
      end
    end
  end
end
