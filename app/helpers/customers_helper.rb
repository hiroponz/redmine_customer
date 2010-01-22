require 'ostruct'

module CustomersHelper
  # retorna um objeto que pode ser usado no lugar de um JournalDetail,
  # pra poder usar um helper do redmine
  def change_to_detail(attr, values)
    # hack pro helper do redmine formatar como data
    key = values.last.is_a?(Date) ? 'start_date' : attr
    OpenStruct.new(
      :property => 'attr',
      :prop_key => key,
      :old_value => values.first.to_s,
      :value => values.last.to_s
    )
  end

  def link_to_tasks(customer)
    link_to 'Tarefas', {
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
    link_to 'Nova Tarefa', {
      :controller => 'issues',
      :action => 'new',
      :project_id => params[:project_id],
      :customer_id => customer.id
    },
    :class => 'icon icon-folder'
  end
end
