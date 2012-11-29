# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hactor/version'

Gem::Specification.new do |gem|
  gem.name          = "hactor"
  gem.version       = Hactor::VERSION
  gem.authors       = ["Mike Kelly"]
  gem.email         = ["mikekelly321@gmail.com"]
  gem.description   = %q{A framework for building hypermedia clients}
  gem.summary       = %q{A framework for building hypermedia clients}
  gem.homepage      = "https://github.com/mikekelly/hactor"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rspec'
  gem.add_dependency 'faraday'
end
