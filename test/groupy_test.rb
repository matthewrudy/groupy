require 'test_helper'

require 'groupy'

class GroupyTest < ActiveSupport::TestCase
  
  class Food

    def initialize(dish)
      @dish = dish
    end
    attr_reader :dish

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
  end

end
