# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ticktok_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "ticktok-cli"
  spec.version       = TicktokCli::VERSION
  spec.authors       = ["Eli Segal"]
  spec.email         = ["eli.segal@gmail.com"]
  spec.description   = %q{CLI for Ticktok.io}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/ticktok-io/ticktok-cli"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "colorize"
  spec.add_dependency "rest-client"
  spec.add_dependency "bunny"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
