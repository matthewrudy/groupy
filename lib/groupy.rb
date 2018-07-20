# frozen_string_literal: true

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
    def groupy(column, options = {}, &block)
      container = OuterGroup.new(&block)
      container.attach!(self, column, options)
      groupies[column] = container
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
      value_groups.map(&:value)
    end

    def value_groups
      sub_groups.inject([]) do |array, sg|
        if sg.is_a?(Value)
          array << sg
        else
          array + sg.value_groups
        end
      end
    end

    def subgroups
      sub_groups.each_with_object({}) do |g, hash|
        hash.merge!(g.subgroups) if g.respond_to?(:subgroups)
        hash[g.name] = g.values
      end
    end

    private

    def group(name, &block)
      subgroup = Group.new(name, &block)
      sub_groups << subgroup
    end

    def value(name)
      sub_groups << Value.new(name)
    end
  end

  class OuterGroup < Group
    def initialize(&block)
      super(:all, &block)
    end

    def subgroups
      super().merge(all: values)
    end

    def attach!(klass, column_name, options)
      subgroups.each do |group_name, group_values|
        next if group_name == :all
        method_name =
          if options[:suffix]
            "#{group_name}_#{column_name}"
          else
            group_name
          end

        klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method_name}?
            #{group_values.inspect}.include?(self.#{column_name})
          end
        RUBY

        scope_name = method_name.to_s.pluralize

        next unless defined?(ActiveRecord) && klass < ActiveRecord::Base
        klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{scope_name}
            where(#{column_name.inspect} => #{group_values.inspect})
          end
        RUBY
      end

      if options[:constants]
        value_groups.each do |value_group|
          constant_name =
            if options[:suffix]
              "#{value_group.name}_#{column_name}"
            else
              value_group.name
            end
          klass.const_set(constant_name.to_s.upcase.to_s, value_group.value)
        end
      end

      klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
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
      @name  = name.to_s.gsub('::', '').underscore.to_sym
      @value = name.to_s.freeze
    end
    attr_reader :name, :value

    def values
      [value]
    end
  end
end
