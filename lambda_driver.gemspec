# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lambda_driver/version'

Gem::Specification.new do |gem|
  gem.name          = "lambda_driver"
  gem.version       = LambdaDriver::VERSION
  gem.authors       = ["Tomohito Ozaki"]
  gem.email         = ["ozaki@yuroyoro.com"]
  gem.description   = %q{Drives your code more functioal!}
  gem.summary       = %q{Drives your code more functioal!}
  gem.homepage      = "http://yuroyoro.github.com/lambda_driver/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # dependencies
  gem.add_development_dependency 'rspec'
end
