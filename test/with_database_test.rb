# frozen_string_literal: true

require 'test_helper'

require 'groupy'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: (RUBY_PLATFORM == 'java' ? 'jdbcsqlite3' : 'sqlite3'),
  database: ':memory:'
)

ActiveRecord::Schema.define(version: 0) do
  create_table :somethings, force: true do |t|
    t.string :size
  end
end

class Something < ActiveRecord::Base
  include Groupy

  groupy :size, suffix: true do
    value :small
    value :medium
    value :large
  end
end

class WithDatabaseTest < ActiveSupport::TestCase
  test 'scopes' do
    assert_equal [], Something.small_sizes.all
    assert_equal 0,  Something.small_sizes.count
    assert_equal [], Something.medium_sizes.all
    assert_equal 0,  Something.medium_sizes.count

    small1 = Something.create!(size: 'small')
    medium = Something.create!(size: 'medium')
    small2 = Something.create!(size: 'small')

    assert_equal [small1, small2], Something.small_sizes.all
    assert_equal 2,                Something.small_sizes.count
    assert_equal [medium],         Something.medium_sizes.all
    assert_equal 1,                Something.medium_sizes.count
  end

  test 'subgroup shortcut' do
    assert_equal %w[small medium large], Something.sizes(:all)
    assert_equal %w[small medium large], Something.all_sizes
    assert_equal ['small'], Something.sizes(:small)
  end
end
