# -*- encoding: utf-8 -*-
# stub: sinatra 1.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sinatra".freeze
  s.version = "1.4.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Blake Mizerany".freeze, "Ryan Tomayko".freeze, "Simon Rozet".freeze, "Konstantin Haase".freeze]
  s.date = "2013-03-15"
  s.description = "Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort.".freeze
  s.email = "sinatrarb@googlegroups.com".freeze
  s.extra_rdoc_files = ["README.de.md".freeze, "README.es.md".freeze, "README.fr.md".freeze, "README.hu.md".freeze, "README.jp.md".freeze, "README.ko.md".freeze, "README.md".freeze, "README.pt-br.md".freeze, "README.pt-pt.md".freeze, "README.ru.md".freeze, "README.zh.md".freeze, "LICENSE".freeze]
  s.files = ["LICENSE".freeze, "README.de.md".freeze, "README.es.md".freeze, "README.fr.md".freeze, "README.hu.md".freeze, "README.jp.md".freeze, "README.ko.md".freeze, "README.md".freeze, "README.pt-br.md".freeze, "README.pt-pt.md".freeze, "README.ru.md".freeze, "README.zh.md".freeze]
  s.homepage = "http://www.sinatrarb.com/".freeze
  s.rdoc_options = ["--line-numbers".freeze, "--inline-source".freeze, "--title".freeze, "Sinatra".freeze, "--main".freeze, "README.rdoc".freeze, "--encoding=UTF-8".freeze]
  s.rubygems_version = "1.8.23".freeze
  s.summary = "Classy web-development dressed in a DSL".freeze

  s.installed_by_version = "3.5.23".freeze

  s.specification_version = 3

  s.add_runtime_dependency(%q<rack>.freeze, ["~> 1.5".freeze, ">= 1.5.2".freeze])
  s.add_runtime_dependency(%q<tilt>.freeze, ["~> 1.3".freeze, ">= 1.3.4".freeze])
  s.add_runtime_dependency(%q<rack-protection>.freeze, ["~> 1.4".freeze])
end
