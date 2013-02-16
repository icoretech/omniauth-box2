# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-box2/version'

Gem::Specification.new do |gem|
  gem.name          = "omniauth-box2"
  gem.version       = Omniauth::Box2::VERSION
  gem.authors       = ["Claudio Poli"]
  gem.email         = ["masterkain@gmail.com\n"]
  gem.description   = %q{OmniAuth strategy for Box}
  gem.summary       = %q{OmniAuth strategy for Box}
  gem.homepage      = "https://github.com/masterkain/omniauth-box2"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'omniauth', '~> 1.0'
end
