# -*- encoding: utf-8 -*-
# stub: danger-gitlab 8.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "danger-gitlab".freeze
  s.version = "8.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Orta Therox".freeze, "Juanito Fatas".freeze]
  s.date = "2020-05-19"
  s.description = "Stop Saying 'You Forgot To\u2026' in Code Review with GitLab".freeze
  s.email = ["orta.therox@gmail.com".freeze, "me@juanitofatas.com".freeze]
  s.homepage = "http://github.com/danger/danger".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Stop Saying 'You Forgot To\u2026' in Code Review with GitLab".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<danger>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<gitlab>.freeze, [">= 4.2.0", "~> 4.2"])
  else
    s.add_dependency(%q<danger>.freeze, [">= 0"])
    s.add_dependency(%q<gitlab>.freeze, [">= 4.2.0", "~> 4.2"])
  end
end
