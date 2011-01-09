# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{groupy}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Rudy Jacobs"]
  s.date = %q{2011-01-09}
  s.email = %q{MatthewRudyJacobs@gmail.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "MIT-LICENSE", "Rakefile", "test/test_helper.rb", "test/groupy_test.rb", "lib/groupy.rb"]
  s.homepage = %q{https://github.com/matthewrudy/groupy}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.1}
  s.summary = %q{Categorise with nested groups}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
