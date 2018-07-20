# frozen_string_literal: true

require 'test_helper'

require 'groupy'

class GroupyTest < ActiveSupport::TestCase
  class Food
    def initialize(dish)
      @dish = dish
      @spiciness = 'small'
    end
    attr_reader :dish
    attr_reader :spiciness
    attr_reader :smelliness

    include Groupy
    groupy :dish do
      group :healthy do
        group :fruit do
          value :apple
          value :orange
        end
        value :rice
      end

      group :unhealthy do
        value :fried_egg
        value :bacon
      end
    end

    # we can have multiple groupies
    groupy :spiciness, suffix: true, constants: true do
      group :wussy do
        value :small
      end
      value :extreme
    end

    # we can do constants without suffices too
    groupy :smelliness, constants: true do
      value :very_smelly
      value :hardly_smelly
    end
  end

  test 'groupies' do
    groupy = Food.groupies[:dish]
    assert_instance_of Groupy::OuterGroup, groupy
  end

  test 'subgroups' do
    assert_equal %i[all healthy fruit apple orange rice unhealthy fried_egg bacon].sort_by(&:to_s), Food.groupies[:dish].subgroups.keys.sort_by(&:to_s)
    assert_equal %w[apple orange rice], Food.groupies[:dish].subgroups[:healthy]
    assert_equal %w[apple orange], Food.groupies[:dish].subgroups[:fruit]
    assert_equal ['apple'], Food.groupies[:dish].subgroups[:apple]
  end

  test 'all_' do
    assert_equal %w[apple orange rice fried_egg bacon].sort, Food.all_dishes.sort
  end

  test '? methods' do
    orange = Food.new('orange')

    # not suffixed
    assert orange.healthy?
    assert !orange.rice?
    assert orange.fruit?
    assert orange.orange?

    # suffixed
    assert orange.wussy_spiciness?
    assert orange.small_spiciness?
    assert !orange.extreme_spiciness?
  end

  test 'constants' do
    # suffixed
    assert_equal 'small',   Food::SMALL_SPICINESS
    assert_equal 'extreme', Food::EXTREME_SPICINESS

    # not suffixed
    assert_equal 'very_smelly', Food::VERY_SMELLY
  end

  class Thing
    include Groupy

    def initialize(type)
      @type = type
    end
    attr_reader :type

    groupy :type do
      group :number do
        value :FixNum
        value 'My::FixNum'
      end
      value :String
    end
  end

  test 'underscore value methods' do
    number = Thing.new('My::FixNum')
    assert number.number?
    assert !number.fix_num?
    assert number.my_fix_num?
    assert !number.string?
  end
end
