lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/teamsx/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-teamsx'
  spec.version       = Fastlane::Teamsx::VERSION
  spec.author        = 'Ankun'
  spec.email         = 'sytungan@gmail.com'

  spec.summary       = 'Deliver message to MSTeams'
  spec.homepage      = "https://github.com/sytungan/fastlane-plugin-teamsx"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.5'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'
end
