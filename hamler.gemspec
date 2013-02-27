# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hamler/version'

Gem::Specification.new do |gem|
  gem.name          = "hamler"
  gem.version       = Hamler::VERSION
  gem.authors       = ["Wang Guan"]
  gem.email         = ["momocraft@gmail.com"]
  gem.description   = %q{one-line haml/sass/scss compiler}
  gem.summary       = %q{compile haml/sass/scss files in one command}
  gem.homepage      = "https://github.com/jokester/hamler"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "thor"
  gem.add_runtime_dependency "haml"
  gem.add_runtime_dependency "sass"
  gem.add_runtime_dependency "coffee-script"
  gem.add_runtime_dependency "execjs"
end
