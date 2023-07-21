# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :customer_state, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]
  
  def after_sign_in_path_for(resource)
    if current_customer # 既存ユーザーか？
      customers_path
    else
      customers_path
    end
  end
 
  def after_sign_out_path_for(resource)
    root_path
  end
  
  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    flash[:info] = "ゲストユーザーとしてログインしました。"
    redirect_to root_path
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

 protected
  # 退会しているかを判断するメソッド
  def customer_state
    @customer = Customer.find_by(email: params[:customer][:email])
    if @customer
      if @customer.valid_password?(params[:customer][:password]) && (@customer.is_deleted == true)
        flash[:warning] = "退会済みです。再度ご登録をしてご利用ください"
        redirect_to new_customer_registration_path
      else
      end
    else
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
