# frozen_string_literal: true

require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test Groupy.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for Groupy.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Groupy'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rubygems/package_task'

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  # Change these as appropriate
  s.name              = 'groupy'
  s.version           = '0.3.1'
  s.summary           = 'Categorise Active Records in nested groups with magical scopes, ? methods, and constants.'
  s.author            = 'Matthew Rudy Jacobs'
  s.email             = 'MatthewRudyJacobs@gmail.com'
  s.homepage          = 'https://github.com/matthewrudy/groupy'

  s.extra_rdoc_files  = %w[README.md]
  s.rdoc_options      = %w[--main README.md]

  # Add any extra files to include in the gem
  s.files             = %w[README.md MIT-LICENSE Rakefile] + Dir.glob('{test,lib}/**/*')
  s.require_paths     = ['lib']

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  s.add_dependency('activesupport')

  # If your tests use any gems, include them here
  s.add_development_dependency('activerecord')
  s.add_development_dependency('minitest')
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rubocop')
  s.add_development_dependency('sqlite3-ruby')
  s.add_development_dependency('test-unit')
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more
# about that here: http://gemcutter.org/pages/gem_docs
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') { |f| f << spec.to_ruby }
end

# If you don't want to generate the .gemspec file, just remove this line. Reasons
# why you might want to generate a gemspec:
#  - using bundler with a git source
#  - building the gem without rake (i.e. gem build blah.gemspec)
#  - maybe others?
task :package => :gemspec

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
