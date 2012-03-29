# -*- encoding: utf-8 -*-
require File.expand_path('../lib/grocer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Andy Lindeman', 'Steven Harman']
  gem.email         = ['andy@highgroove.com', 'steven@highgroove.com']
  gem.description   = %q{Pushing your Apple notifications since 2012.}
  gem.summary       = %q{Pushing your Apple notifications since 2012.}
  gem.homepage      = 'https://github.com/highgroove/grocer'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "grocer"
  gem.require_paths = ["lib"]
  gem.version       = Grocer::VERSION

  gem.add_development_dependency 'rspec', '~> 2.9.0'
  gem.add_development_dependency 'pry', '~> 0.9.8'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'bourne'
  gem.add_development_dependency 'rake'
end
