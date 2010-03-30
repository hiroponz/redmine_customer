require 'ostruct'

module CustomersHelper
  # retorna um objeto que pode ser usado no lugar de um JournalDetail,
  # pra poder usar um helper do redmine
  def change_to_detail(customer, attr, values)
    if attr =~ /^cf-\d+$/
      change_to_custom_field(attr, values)
    else
      change_to_attr(attr, values)
    end
  end

  def change_to_attr(attr, values)
    # hack pro helper do redmine formatar como data
    key = values.last.is_a?(Date) ? 'start_date' : attr
    OpenStruct.new(
      :property => 'attr',
      :prop_key => key,
      :old_value => values.first.to_s,
      :value => values.last.to_s
    )
  end

  def change_to_custom_field(attr, values)
    OpenStruct.new(
      :property => 'cf',
      :prop_key => attr.sub('cf-', ''),
      :old_value => values.first.to_s,
      :value => values.last.to_s
    )
  end

  def link_to_tasks(customer)
    link_to l(:label_issue_plural), {
      :controller => 'issues',
      :action => 'index',
      :project_id => params[:project_id],
      :set_filter => true,
      :fields => [:customer_id],
      :operators => {:customer_id => '=' },
      :values => {:customer_id => [customer.id]}
    },
    :class => 'icon icon-folder'
  end

  def link_to_new_task(customer)
    link_to l(:label_issue_new), {
      :controller => 'issues',
      :action => 'new',
      :project_id => params[:project_id],
      :customer_id => customer.id
    },
    :class => 'icon icon-add'
  end

  def filter_by_custom(field)
    filter_by field.id.to_s, field.name, field.possible_values
  end

  def filter_by(field, label, values = nil)
    content_tag :p do
      label_tag("filter[#{field}][value]", label) +
      operation_tag(field, label) +
      value_tag(field, label, values)
    end
  end

  OPERATORS = {
    '='  => :label_equals,
    '!=' => :label_not_equals,
    "~"  => :label_contains,
    "!~" => :label_not_contains
  }

  def operation_tag(field, label)
    @operators ||= OPERATORS.inject({}){|operators, op| operators.merge(t(op.last) => op.first)}
    select_tag("filter[#{field}][operator]", options_for_select(@operators, params[:filter][field][:operator]))
  end

  def value_tag(field, label, values)
    if values.present?
      select_tag "filter[#{field}][value]", options_for_select([''] + values, params[:filter][field][:value])
    else
      text_field_tag "filter[#{field}][value]", params[:filter][field][:value]
    end
  end
end
