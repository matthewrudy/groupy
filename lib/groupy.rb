require 'active_support/core_ext/class/attribute_accessors'

module Groupy

  def self.included(klass)
    klass.class_eval do
      extend ClassMethods
      
      cattr_accessor :groupies
      self.groupies = {}
    end
  end

  module ClassMethods

    def groupy(column, &block)
      container = OuterGroup.new(&block)
      container.attach!(self, column)
      self.groupies[column] = container
    end

  end

  class Group

    def initialize(name, &block)
      @name = name
      @sub_groups = []

      instance_eval(&block)
    end
    attr_reader :name, :sub_groups
 
    def values
      self.sub_groups.map{|g| g.values}.flatten
    end

    def subgroups
      self.sub_groups.inject({}) do |hash, g|
        if g.respond_to?(:subgroups)
          hash.merge!(g.subgroups)
        end
        hash[g.name] = g.values
        hash
      end
    end

    private

    def group(name, &block)
      subgroup = Group.new(name, &block)
      self.sub_groups << subgroup
    end

    def value(name)
      self.sub_groups << Value.new(name)
    end

  end

  class OuterGroup < Group
    
    def initialize(&block)
      super(:all, &block)
    end

    def attach!(klass, column_name)
      self.subgroups.each do |group_name, group_values|
        klass.class_eval <<-RUBY
          def #{group_name}?
            #{group_values.inspect}.include?(self.#{column_name})
          end
        RUBY
      end
    end
  
  end

  class Value

    def initialize(name)
      @name = name
      @value = name.to_s.freeze
    end
    attr_reader :name, :value
    
    def values
      [value]
    end

  end

end
