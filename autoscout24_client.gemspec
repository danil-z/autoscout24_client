# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autoscout24_client/version'

Gem::Specification.new do |gem|
  gem.name          = "autoscout24_client"
  gem.version       = Autoscout24Client::VERSION
  gem.authors       = ["Danil Zvyagintsev"]
  gem.email         = ["danil@autoservie61.ru"]
  gem.description   = %q{REST client to Autoscout24.de website}
  gem.summary       = %q{Autoscout24 REST client}
  gem.homepage      = "https://github.com/blackbumer/autoscout24_client"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "webmock"

  gem.add_dependency "activesupport"
  gem.add_dependency "rest-client"
  gem.add_dependency "json"
end
