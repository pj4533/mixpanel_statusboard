# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utils/version'

Gem::Specification.new do |spec|
  spec.name          = "mixpanel_statusboard"
  spec.version       = MixPanelSB::VERSION
  spec.authors       = ["David Ohayon"]
  spec.email         = ["david@evertrue.com"]
  spec.summary       = "Generate StatusBoard URLs for MixPanel"
  spec.description   = "Generate StatusBoard URLs for MixPanel"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^utils/bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_dependency 'commander'
  spec.add_dependency 'sinatra', '1.1.0'
  spec.add_dependency 'mixpanel_client'

end