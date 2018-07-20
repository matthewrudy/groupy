# frozen_string_literal: true

# stub: groupy 0.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = 'groupy'
  s.version = '0.3.1'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.require_paths = ['lib']
  s.authors = ['Matthew Rudy Jacobs']
  s.date = '2018-07-20'
  s.email = 'MatthewRudyJacobs@gmail.com'
  s.extra_rdoc_files = ['README.md']
  s.files = ['MIT-LICENSE', 'README.md', 'Rakefile', 'lib/groupy.rb', 'test/groupy_test.rb', 'test/test_helper.rb', 'test/with_database_test.rb']
  s.homepage = 'https://github.com/matthewrudy/groupy'
  s.rdoc_options = ['--main', 'README.md']
  s.rubygems_version = '2.7.7'
  s.summary = 'Categorise Active Records in nested groups with magical scopes, ? methods, and constants.'

  if s.respond_to? :specification_version
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      s.add_runtime_dependency('activesupport', ['>= 0'])
      s.add_development_dependency('activerecord', ['>= 0'])
      s.add_development_dependency('minitest', ['>= 0'])
      s.add_development_dependency('rake', ['>= 0'])
      s.add_development_dependency('rdoc', ['>= 0'])
      s.add_development_dependency('rubocop', ['>= 0'])
      s.add_development_dependency('sqlite3-ruby', ['>= 0'])
      s.add_development_dependency('test-unit', ['>= 0'])
    else
      s.add_dependency('activerecord', ['>= 0'])
      s.add_dependency('activesupport', ['>= 0'])
      s.add_dependency('minitest', ['>= 0'])
      s.add_dependency('rake', ['>= 0'])
      s.add_dependency('rdoc', ['>= 0'])
      s.add_dependency('rubocop', ['>= 0'])
      s.add_dependency('sqlite3-ruby', ['>= 0'])
      s.add_dependency('test-unit', ['>= 0'])
    end
  else
    s.add_dependency('activesupport', ['>= 0'])
    s.add_dependency('activesupport', ['>= 0'])
    s.add_dependency('minitest', ['>= 0'])
    s.add_dependency('rake', ['>= 0'])
    s.add_dependency('rdoc', ['>= 0'])
    s.add_dependency('rubocop', ['>= 0'])
    s.add_dependency('sqlite3-ruby', ['>= 0'])
    s.add_dependency('test-unit', ['>= 0'])
  end
end
