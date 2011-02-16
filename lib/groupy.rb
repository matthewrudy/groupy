require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/string/inflections'

module Groupy

  def self.included(klass)
    klass.class_eval do
      extend ClassMethods
      
      cattr_accessor :groupies
      self.groupies = {}
    end
  end

  module ClassMethods

    def groupy(column, options={}, &block)
      container = OuterGroup.new(&block)
      container.attach!(self, column, options)
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
      value_groups.map{|g| g.value}
    end
    
    def value_groups
      self.sub_groups.inject([]) do |array, sg|
        if sg.is_a?(Value)
          array << sg
        else
          array += sg.value_groups
        end
      end
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
    
    def subgroups
      super().merge(:all => self.values)
    end
    
    def attach!(klass, column_name, options)
      self.subgroups.each do |group_name, group_values|

        method_name = if options[:suffix]
          "#{group_name}_#{column_name}"
        else
          group_name
        end

        klass.class_eval <<-RUBY
          def #{method_name}?
            #{group_values.inspect}.include?(self.#{column_name})
          end
        RUBY
        
        scope_name = method_name.to_s.pluralize
        
        if defined?(ActiveRecord) && klass < ActiveRecord::Base
          klass.scope(scope_name, klass.where(column_name => group_values))
        end
      end
      
      if options[:constants]
        self.value_groups.each do |value_group|
          
          constant_name = if options[:suffix]
            "#{value_group.name}_#{column_name}"
          else
            value_group.name
          end
          klass.const_set("#{constant_name.to_s.upcase}", value_group.value)
        end
      end
      
      klass.class_eval <<-RUBY
        def self.all_#{column_name.to_s.pluralize}
          self.#{column_name.to_s.pluralize}(:all)
        end
        
        # self.roles(:non_superadmin) => ["some", "list", "of", "roles"]
        def self.#{column_name.to_s.pluralize}(subgroup_name)
          self.groupies[#{column_name.inspect}].subgroups[subgroup_name]
        end
      RUBY
    end
  
  end

  class Value

    def initialize(name)
      @name  = name.to_s.gsub("::", "").underscore.to_sym
      @value = name.to_s.freeze
    end
    attr_reader :name, :value
    
    def values
      [value]
    end

  end

end
