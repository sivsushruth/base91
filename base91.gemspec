# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'base91/version'

Gem::Specification.new do |spec|
  spec.name          = "base91"
  spec.version       = Base91::VERSION
  spec.authors       = ["sivsushruth"]
  spec.email         = ["sivsushruth@gmail.com"]
  spec.summary       = "basE91 encoder and decoder"
  spec.homepage      = "https://github.com/sivsushruth/base91"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2.0"
end