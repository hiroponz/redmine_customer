# Hooks to attach to the Redmine Issues.
class CustomerIssueHook < Redmine::Hook::ViewListener

  # Renders the Customer name
  #
  # Context:
  # * :issue => Issue being rendered
  #
  def view_issues_show_details_bottom(context = { })
    if context[:project].module_enabled?('customer-plugin')
      data = "<td><b>#{l(:label_customer)}:</b></td>"
      if customer = context[:issue].customer
        customer_link = link_to customer.to_s, {:controller => 'customers', :action => 'show', :project_id => customer.project_id, :id => customer }
        data << "<td>#{customer_link unless customer.nil?}</td>"
      end
      "<tr>#{data}<td></td></tr>"
    end
  end
  
  # Renders a select tag with all the Customers
  #
  # Context:
  # * :form => Edit form
  # * :project => Current project
  #
  def view_issues_form_details_bottom(context = { })
    if context[:project].module_enabled?('customer-plugin')
      customers = context[:project].customers
      select = context[:form].select :customer_id, customers.collect{|c| [c.to_s, c.id]}

      text_field = text_field_tag :customer_text, context[:form].object.customer.to_s
      link = link_to('Cadastrar', {:controller => 'customers', :action => 'new', :project_id => context[:project].id}, :target => '_blank')
      autocomplete = javascript_tag <<-JS
        new Ajax.Autocompleter(
          'customer_text',
          'customer_id_choices',
          '#{url_for(:controller => 'customers', :action => 'autocomplete', :project_id => context[:project].id)}',
          {
            minChars: 0,
            frequency: 0.5,
            paramName: 'q',
            afterUpdateElement: function(text, li) {
              $("issue_customer_id").value = li.id;
            }
          });
      JS

      return "
        <p>#{select} - #{text_field} - #{link}</p>
        <div id=\"customer_id_choices\" class=\"autocomplete\"></div>
        #{autocomplete}
      "
    end
  end
  
  # Renders a select tag with all the Customers for the bulk edit page
  #
  # Context:
  # * :project => Current project
  #
  def view_issues_bulk_edit_details_bottom(context = { })
    if context[:project].module_enabled?('customer-plugin')
      select = select_tag('customer_id',
                               content_tag('option', l(:label_no_change_option), :value => '') +
                               content_tag('option', l(:label_none), :value => 'none') +
                               options_from_collection_for_select(Customer.all, :id, :to_s))

      content_tag(:p, "<label>#{l(:customer_label)}: " + select + "</label>")
    end
  end
  
  # Saves the Customer assignment to the issue
  #
  # Context:
  # * :issue => Issue being saved
  # * :params => HTML parameters
  #
  def controller_issues_bulk_edit_before_save(context = { })
    if context[:project].module_enabled?('customer-plugin')
      case true

      when context[:params][:customer_id].blank?
        # Do nothing
      when context[:params][:customer_id] == 'none'
        # Unassign customer
        context[:issue].customer = nil
      else
        context[:issue].customer = Customer.find(context[:params][:customer_id])
      end

      return ''
    end
  end
  
  # Customer changes for the journal use the Customer string
  # instead of the id
  #
  # Context:
  # * :detail => Detail about the journal change
  #
  def helper_issues_show_detail_after_setting(context = { })
    # TODO Later: Overwritting the caller is bad juju
    if context[:detail].prop_key == 'customer_id'
      c = Customer.find_by_id(context[:detail].value)
      context[:detail].value = c.to_s unless c.nil?

      c = Customer.find_by_id(context[:detail].old_value)
      context[:detail].old_value = c.to_s unless c.nil?
    end
    ''
  end
end

