require_relative 'lib/alfa_merger/version'

Gem::Specification.new do |spec|
  spec.name = "alfa_merger"
  spec.license = "MIT"
  spec.version = AlfaMerger::VERSION
  spec.authors = ["BigForceGun"]
  spec.email = ["BigForceGun@gmail.com"]

  spec.summary = %q{ALFA Bank CSV export transaction merger for Firefly III}
  spec.description = %q{ALFA Bank CSV export transaction merger for Firefly III}
  spec.homepage = "https://github.com/bigforcegun/alfa_merger"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bigforcegun/alfa_merger"
  spec.metadata["changelog_uri"] = "https://github.com/bigforcegun/alfa_merger/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry-byebug", "~> 3.9.0"
  spec.add_development_dependency "rubocop", "~> 0.86.0"

  spec.add_dependency "thor", "~> 0.20.0"
  spec.add_dependency "tty-table", "~> 0.11.0"
  spec.add_dependency "tty-progressbar", "~> 0.17.0"
  spec.add_dependency "runcom", "~> 2.0.1"
  spec.add_dependency "sequel", "~> 5.33.0"
  spec.add_dependency "sqlite3", "~>  1.3.11"
end
