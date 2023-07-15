class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!, only: [:edit, :update, :withdrawal]
  before_action :set_customer, only: [:edit, :update, :withdrawal]
  
  def show
    @customer = current_customer
    
  end

  def edit
    
  end

  def update
    if @customer.update(customer_params)
      flash[:success] = "会員情報が更新されました。"
      redirect_to customers_path
    else
      flash.now[:danger] = '未記入項目があります'
      render :edit
    end
  end

  def check
  end

  def withdrawal
    @customer.update(is_deleted: true)
    reset_session
    flash[:danger] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :nickname, :profile_image, :email, :is_deleted, :is_hidden)
  end
  
  def set_customer
    @customer = Customer.find(current_customer.id)
  end
end
