# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'couch_replica/version'

Gem::Specification.new do |spec|
  spec.name          = "couch_replica"
  spec.version       = CouchReplica::VERSION
  spec.authors       = ["Gordon L. Hempton"]
  spec.email         = ["ghempton@gmail.com"]

  spec.summary       = "Utility to replicate *all* databases from a CouchDB server"
  spec.homepage      = "https://github.com/getoutreach/couch_replica"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "couch_replica"
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client'
  spec.add_dependency 'thor'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
