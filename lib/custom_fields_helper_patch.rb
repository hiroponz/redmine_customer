module CustomerCustomFieldsHelperPatch
  def self.included(base)
    base.class_eval do
      alias_method_chain :custom_fields_tabs, :customer_tab
    end
  end

  def custom_fields_tabs_with_customer_tab
    customer_tab = {:name => 'CustomerCustomField', :partial => 'custom_fields/index', :label => :label_customer_plural}
    custom_fields_tabs_without_customer_tab << customer_tab
  end
end
