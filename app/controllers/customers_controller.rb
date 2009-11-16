class CustomersController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project
  before_filter :find_customer, :only => [:show, :edit, :update, :destroy]
 
  def index
    @customers = @project.customers
  end

  def autocomplete
    @customers = @project.customers.search params[:q]
    render :layout => false
  end

  def show
    render
  end

  def edit
    render
  end

  def update
    if @customer.update_attributes(params[:customer])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => "show", :project_id => params[:project_id], :id => params[:id]
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
    redirect_to :action => "index", :project_id => params[:project_id]
  end
  
  def new
    @customer = Customer.new
  end

  def create
    @customer = @project.customers.build(params[:customer])
    if @customer.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => "show", :project_id => params[:project_id], :id => @customer.id
    else
      render :action => "new"
    end
  end
  
  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_customer
    @customer = @project.customers.find(params[:id])
  end
end
