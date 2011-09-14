# -*- encoding: utf-8 -*-
require_relative "lib/suggestor/version"

Gem::Specification.new do |s|
  s.name        = "suggestor"
  s.version     = Suggestor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alvaro Pereyra"]
  s.email       = ["alvaro@xendacentral.com"]
  s.homepage    = ""
  s.summary     = %q{Suggestor allows you to get suggestions of related items in your data}
  s.description = %q{Suggestor allows you to get suggestions of related items in your data}

  s.rubyforge_project = "suggestor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
