require_dependency 'query'

module QueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      base.add_available_column(QueryColumn.new(:customer, :sortable => "#{Customer.table_name}.name"))
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

    # Wrapper around the +available_filters+ to add a new Deliverable filter
    def available_filters_with_customer_filters
      return @available_filters if @available_filters
      @available_filters = available_filters_without_customer_filters
      if project
        customer_filters = { "customer_id" => { :type => :list_optional, :order => 14,
            :values => Customer.find(:all, :conditions => ["project_id IN (?)", project], :order => 'name ASC').collect { |c| [c.name, c.id.to_s]}
          }}
      else
        customer_filters = { }
      end
      @available_filters.merge(customer_filters)
    end
  end    
end

