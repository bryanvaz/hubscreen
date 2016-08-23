# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hubscreen/version'

Gem::Specification.new do |spec|
  spec.name          = "hubscreen"
  spec.version       = Hubscreen::VERSION
  spec.authors       = ["Bryan Vaz"]
  spec.email         = ["open-source@improvemy.it"]
  spec.date          = "2016-08-22"

  spec.summary       = "Multi-purpose Ruby wrapper for the Hubspot CRM API"
  spec.description   = "Multi-purpose Ruby wrapper for the Hubspot CRM API with access to the raw response or Ruby objects for faster development"
  spec.homepage      = "https://github.com/bryanvaz/hubscreen"
  spec.license       = "MIT"

  spec.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  
  #For Testing
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.1"
  
  #Interactive Testing
  spec.add_development_dependency 'pry-byebug'

  #Gem Dependancies
  spec.add_dependency(%q<activesupport>, [">= 4"])
  spec.add_dependency('faraday', '>= 0.8')
  spec.add_dependency('multi_json', '>= 1')
  spec.add_dependency('recursive-open-struct', '>= 1.0')

end
