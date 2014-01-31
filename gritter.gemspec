# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gritter/version"

Gem::Specification.new do |s|
  s.name        = "gritter"
  s.version     = Gritter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robin Brouwer"]
  s.email       = ["robin@montblanc.nl"]
  s.homepage    = "http://www.montblanc.nl"
  s.summary     = %q{Growl notifications for your Rails application.}
  s.description = %q{This Ruby on Rails gem allows you to easily add Growl-like notifications to your application using a jQuery plugin called 'gritter'.}
  
  s.rubyforge_project = "nowarning"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
