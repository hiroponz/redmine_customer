require_dependency 'query'

module QueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      base.add_available_column(QueryColumn.new(:customer_id, :sortable => "#{Customer.table_name}.name"))
      alias_method_chain :available_filters, :customer_filters
    end

  end

  module ClassMethods

    # Setter for +available_columns+ that isn't provided by the core.
    def available_columns=(v)
      self.available_columns = (v)
    end

    # Method to add a column to the +available_columns+ that isn't provided by the core.
    def add_available_column(column)
      self.available_columns << (column)
    end
  end

  module InstanceMethods
    def available_filters_with_customer_filters
      return @available_filters if @available_filters
      customer_filter = project.present? ? { "customer_id" => { :type => :list, :values => project.customers.list_for_select, :order => 30} } : {}
      @available_filters = available_filters_without_customer_filters.merge(customer_filter)
    end
  end    
end

