# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'BOBrb/version'

Gem::Specification.new do |spec|
  spec.name          = "BOBrb"
  spec.version       = BOBrb::VERSION
  spec.authors       = ["Stephan Nordnes Eriksen"]
  spec.email         = ["stephanruler@gmail.com"]

  spec.summary       = %q{BOB: Powerful XML and HTML building}
  spec.description   = %q{BOB is a simple and powerfull ruby pipe system for building complex XML and HTML structures.}
  spec.homepage      = "https://github.com/stephan-nordnes-eriksen/BOBrb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "codeclimate-test-reporter", "~>0.4"

end
