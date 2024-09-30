# frozen_string_literal: true

require_relative "lib/open_feature/flagsmith/provider/version"

Gem::Specification.new do |spec|
  spec.name = "open_feature-flagsmith-provider"
  spec.version = OpenFeature::Flagsmith::Provider::VERSION
  spec.authors = ["Benjamin Chauvette"]
  spec.email = ["ben@chvtt.net"]

  spec.summary = "OpenFeature Provider for Flagsmith"
  spec.homepage = "https://github.com/bdchauvette/open_feature-flagsmith-provider"
  spec.license = "BSD-3-Clause"
  spec.required_ruby_version = ">= 3.1.4"
  spec.require_paths = ["lib"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bdchauvette/open_feature-flagsmith-provider"
  spec.metadata["changelog_uri"] = "https://github.com/bdchauvette/open_feature-flagsmith-provider/blob/main/CHANGELOG.md"

  spec.metadata["github_repo"] = "ssh://github.com/bdchauvette/open_feature-flagsmith-provider"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.add_dependency "flagsmith", "~> 4.1.1"
  spec.add_dependency "openfeature-sdk", "~> 0.4.0"

  spec.add_development_dependency "minitest", "~> 5.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
end
