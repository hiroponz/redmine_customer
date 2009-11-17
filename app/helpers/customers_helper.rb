module CustomersHelper
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
end
