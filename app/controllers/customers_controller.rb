class CustomersController < ApplicationController
  unloadable
  layout 'base'

  before_filter :find_project, :authorize
  before_filter :find_customer, :except => [:index, :new, :create, :autocomplete]
  before_filter :authorize

  helper :issues, :custom_fields
 
  def index
    params[:filter] ||= {}
    if params[:q]
      @customers = @project.customers.search params[:q]
    else
      @customers = @project.customers.all(:conditions => conditions, :include => :custom_values)
    end
  end

  def autocomplete
    @customers = @project.customers.search params[:q]
    render :layout => false
  end

  def show
    render
  end

  def mail
    CustomerMailer.deliver_single_message(@customer, params)
    flash[:notice] = l(:notice_email_sent, @customer.email)
    redirect_to customer_url(@customer, :project_id => params[:project_id])
  end

  def edit
    render
  end

  def update
    if @customer.update_attributes(params[:customer])
      flash[:notice] = l(:notice_successful_update)
      redirect_to customer_url(@customer, :project_id => params[:project_id])
    else
      render :action => "edit", :project_id => params[:project_id], :id => params[:id]
    end
  end

  def destroy
    if @customer.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    redirect_to customers_url(:project_id => params[:project_id])
  end
  
  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(params[:customer])
    if @customer.save
      @customer.projects << @project
      flash[:notice] = l(:notice_successful_create)
      redirect_to customer_url(@customer, :project_id => params[:project_id])
    else
      render :action => "new"
    end
  end

  private

  def conditions
    builder = ARCondition.new()
    filter = params[:filter].dup
    builder.add ["#{Customer.table_name}.name like ?", "%#{filter.delete(:name)}%"] 
    builder.add ["#{Customer.table_name}.email like ?", "%#{filter.delete(:email)}%"] 
    filter.each do |name, value|
      builder.add ["#{CustomValue.table_name}.custom_field_id = ? and #{CustomValue.table_name}.value like ?", name, "%#{value}%"] if value.present?
    end
    builder.conditions
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_customer
    @customer = Customer.find(params[:id])
  end
end
