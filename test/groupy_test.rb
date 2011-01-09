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

end
