class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_customer, only: [:show, :edit, :update]
  
  
  def index
    @q = Customer.ransack(params[:q])
    @customers = @q.result(distinct: true).page(params[:page]).per(10)
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @customer.update(customer_params)
      flash[:success] = "#{@customer.name}さんの会員情報が更新されました。"
      redirect_to admin_customer_path(params[:id])
    else 
      flash.now[:warning] = '未記入項目があります'
      render :edit
    end
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:name, :nickname, :profile_image, :email, :is_deleted, :is_hidden)
  end
  
  def set_customer
    @customer = Customer.find(params[:id])
  end
  
end
