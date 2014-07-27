# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'todo/version'

Gem::Specification.new do |spec|
  spec.name          = "todo"
  spec.version       = Todo::VERSION
  spec.authors       = ["tkak"]
  spec.email         = ["keepkeptkept@gmail.com"]
  spec.summary       = %q{sample todo gem package}
  spec.description   = %q{sample todo gem package}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_dependency "rake"
  spec.add_dependency "yard", "~> 0.8"
  spec.add_dependency "redcarpet"
  spec.add_dependency "activerecord"
  spec.add_dependency "sqlite3", "~> 1.3.9"
end
