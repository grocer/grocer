# -*- encoding: utf-8 -*-
require File.expand_path('../lib/grocer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Andy Lindeman', 'Steven Harman', 'Patrick Van Stee']
  gem.email         = ['alindeman@gmail.com', 'steveharman@gmail.com', 'patrickvanstee@gmail.com']
  gem.summary       = %q{Pushing Apple notifications since 2012.}
  gem.description   = <<-DESC
                          Grocer interfaces with the Apple Push
                          Notification Service to send push
                          notifications to iOS devices and collect
                          notification feedback via the Feedback
                          Service.

                          There are other gems out there to do this,
                          but Grocer plans to be the cleanest, most
                          extensible, and friendliest.
                      DESC
  gem.homepage      = 'https://github.com/grocer/grocer'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "grocer"
  gem.require_paths = ["lib"]
  gem.version       = Grocer::VERSION

  gem.add_development_dependency 'rspec', '~> 3.0.0.rc1'
  gem.add_development_dependency 'pry', '~> 0.9.8'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'bourne'
  gem.add_development_dependency 'rake'
end
