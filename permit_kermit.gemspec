# encoding: utf-8

Gem::Specification.new do |gem|
  gem.authors       = ["Krzysztof Knapik"]
  gem.email         = ["knapo@knapo.net"]
  gem.description   = %q{Simple plugin for role-based permissions}
  gem.summary       = %q{Simple plugin for role-based permissions}
  gem.homepage      = "https://github.com/knapo/permit_kermit"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "a9n"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.2'
end
