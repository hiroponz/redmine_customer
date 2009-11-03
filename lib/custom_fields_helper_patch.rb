require_dependency 'custom_fields_helper'

module CustomFieldsHelperPatch
  def self.included(base)
    base.send :include, InstanceMethods

    base.class_eval do
      alias_method_chain :custom_fields_tabs, :customer_tab
    end
  end

  module InstanceMethods
    # Adds a customer tab to the custom fields administration page
    def custom_fields_tabs_with_customer_tab
      tabs = custom_fields_tabs_without_customer_tab
      tabs << {:name => 'CustomerCustomField', :partial => 'custom_fields/index', :label => :label_customer_plural}
      tabs
    end
  end
end