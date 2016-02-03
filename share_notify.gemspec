# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'share_notify/version'

Gem::Specification.new do |spec|
  spec.name          = 'share_notify'
  spec.version       = ShareNotify::VERSION
  spec.authors       = ['Adam Wead']
  spec.email         = ['amsterdamos@gmail.com']

  spec.summary       = 'Provides basic API integration with ShareNotify'
  spec.description   = 'Provides basic API integration with ShareNotify'
  spec.homepage      = 'https://github.com/projecthydra-labs/share_notify'
  spec.license       = 'APACHE2'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'httparty'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
