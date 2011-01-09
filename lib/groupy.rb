module Groupy

  def self.included(klass)
    klass.class_eval do
      extend ClassMethods
      
      cattr_accessor :groupy_column
      self.groupy_column = :code
    end
  end

  module ClassMethods

    def groupy_group(name, &block)
      group = Group.new(name)
      self.groupy_scope.sub_groups << group if self.groupy_scope

      with_groupy_scope(group, &block)
      # define methods after the groupy
      define_groupy_methods(group)
    end

    def groupy_value(name)
      value = Value.new(name)
      self.groupy_scope.sub_groups << value
      define_groupy_methods(value)
    end

    def groupy_scope
      key = :"#{self}_groupy_scope"
      Thread.current[key]
    end
    
    def groupy_scope=(value)
      key = :"#{self}_groupy_scope"
      Thread.current[key]=value
    end

    def with_groupy_scope(group)
      self.groupy_scope, before = group, self.groupy_scope
      yield
      self.groupy_scope = before
    end
    
    def define_groupy_methods(group)
      underscore = group.name.to_s.gsub("::", "").underscore
      singular_name = "#{underscore}_#{self.groupy_column}"
      collection_name   = singular_name.pluralize
      collection_values = group.values.freeze
      
      self.scope(collection_name, where(self.groupy_column => collection_values))
      
      self.const_set(collection_name.upcase, Array(collection_values).freeze)
      
      if group.is_a?(Groupy::Value)
        self.const_set(singular_name.upcase, collection_values)
      end
      
      define_method("#{singular_name}?") do
        collection_values.include?(self[self.groupy_column].to_s)
      end
    end
    
  end

  class Group

    def initialize(name)
      @name = name
      @sub_groups = []
    end
    attr_reader :name, :sub_groups
 
    def values
      self.sub_groups.map{|g| g.values}.flatten
    end

  end

  class Value

    def initialize(name)
      @name = name
      @value = name.to_s.freeze
    end
    attr_reader :name, :value
    alias :values :value

  end

end
