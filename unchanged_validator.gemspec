# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unchanged_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "unchanged_validator"
  spec.version       = UnchangedValidator::VERSION
  spec.authors       = ["Peter Marsh"]
  spec.email         = ["pete.d.marsh@gmail.com"]
  spec.summary       = "A validator for ActiveModels that checks that attributes have not been modified since the last time the model was saved."
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel", ">= 3.1"

  spec.add_development_dependency "activesupport", ">= 3.1"
  spec.add_development_dependency "appraisal", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
end
