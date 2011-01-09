require 'test_helper'

require 'groupy'

class GroupyTest < ActiveSupport::TestCase
  
  class Food

    def initialize(dish)
      @dish = dish
      @spiciness = "small"
    end
    attr_reader :dish
    attr_reader :spiciness

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
    groupy :spiciness, :suffix => true do
      group :wussy do
        value :small
      end
      value :extreme
    end
    
  end
  
  test "groupies" do
    groupy = Food.groupies[:dish]
    assert_instance_of Groupy::OuterGroup, groupy
  end

  test "subgroups" do
    assert_equal [:healthy, :fruit, :apple, :orange, :rice, :unhealthy, :fried_egg, :bacon].sort_by(&:to_s), Food.groupies[:dish].subgroups.keys.sort_by(&:to_s)
    assert_equal ["apple", "orange", "rice"], Food.groupies[:dish].subgroups[:healthy]
    assert_equal ["apple", "orange"],         Food.groupies[:dish].subgroups[:fruit]
    assert_equal ["apple"],                   Food.groupies[:dish].subgroups[:apple]
  end

  test "? methods" do
    orange = Food.new("orange")
    assert orange.healthy?
    assert !orange.rice?
    assert orange.fruit?
    assert orange.orange?
  
    # and the second groupy
    assert orange.wussy_spiciness?
    assert orange.small_spiciness?
    assert !orange.extreme_spiciness?
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
        value "My::FixNum"
      end
      value :String
    end
  end

  test "underscore value methods" do
    number = Thing.new("My::FixNum")
    assert number.number?
    assert !number.fix_num?
    assert number.my_fix_num?
    assert !number.string?
  end
  
  # TODO: setup an AR test

end
