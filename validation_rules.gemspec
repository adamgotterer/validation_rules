require File.expand_path('../lib/validation_rules/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'validation_rules'
  gem.version     = ValidationRules::VERSION
  gem.date        = '2013-04-05'
  gem.summary     = "A collection of common validation rules"
  gem.description = "A collection of common validation rules"
  gem.authors     = ['Adam Gotterer']
  gem.email       = 'agotterer+gem@gmail.com'
  gem.files       = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  gem.test_files  = Dir.glob("{spec}/**/*") 
  gem.require_paths = ['lib']
  gem.homepage    = 'https://github.com/adamgotterer/validation_rules'

  gem.required_ruby_version = '>= 1.9.2'
  gem.add_development_dependency 'rspec', '>= 1.2.9'
end
