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
      filter_tags(field, label, values)
    end
  end

  TEXT_OPERATORS = {
    "~"  => :label_contains,
    "!~" => :label_not_contains
  }

  LIST_OPERATORS = {
    '='  => :label_equals,
    '!=' => :label_not_equals
  }

  def filter_tags(field, label, values)
    value = params.fetch(:filter, {}).fetch(field, {})[:value]
    if values.present?
      operator_tag(field, label, LIST_OPERATORS) + select_tag("filter[#{field}][value]", options_for_select([''] + values, value))
    else
      operator_tag(field, label, LIST_OPERATORS.merge(TEXT_OPERATORS)) + text_field_tag("filter[#{field}][value]", value)
    end
  end

  def operator_tag(field, label, operators)
    operators = operators.inject({}){|operators, op| operators.merge(t(op.last) => op.first)}
    operator = params.fetch(:filter, {}).fetch(field, {})[:operator]
    select_tag "filter[#{field}][operator]", options_for_select(operators, operator)
  end
end
