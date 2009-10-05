class CustomersController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_customer, :only => [:show, :edit, :update, :destroy]
 
  def index
    @customers = Customer.all
  end

  def autocomplete
    @customers = Customer.search params[:q]
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
      redirect_to :action => "show", :id => params[:id]
    else
      render :action => "edit", :id => params[:id]
    end
  end

  def destroy
    if @customer.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    redirect_to :action => "index"
  end
  
  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(params[:customer])
    if @customer.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => "show", :id => @customer.id
    else
      render :action => "new"
    end
  end
  
  private

  def find_customer
    @customer = Customer.find(params[:id])
  end
end
