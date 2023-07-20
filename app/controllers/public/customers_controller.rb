class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!, only: [:edit, :update, :withdrawal]
  before_action :set_customer, only: [:edit, :update, :withdrawal]
  before_action :ensure_guest_customer, only: [:edit, :withdrawal]
  
  def show
    @customer = params[:customer_id].present? ? Customer.find(params[:customer_id]) : Customer.find(current_customer.id)
    @posts = @customer.posts.page(params[:page]).per(10)
  end
  # いいねした投稿一覧
  def favorites
    @customer = params[:customer_id].present? ? Customer.find(params[:customer_id]) : Customer.find(current_customer.id)
    # @customerに関連付けられたPostFavoritesレコードからpost_idカラムの値を取得
    favorite_post_ids = @customer.post_favorites.pluck(:post_id)
    @favorite_posts = Post.where(id: favorite_post_ids).page(params[:page]).per(10)
  end
  # コメントした投稿一覧
  def comments
    @customer = params[:customer_id].present? ? Customer.find(params[:customer_id]) : Customer.find(current_customer.id)
    # @customerに関連付けられたPostcommentsレコードからpost_idカラムの値を取得
    comments_post_ids = @customer.post_comments.pluck(:post_id)
    @comment_posts = Post.where(id: comments_post_ids).page(params[:page]).per(10)
  end
  
  def edit
  end

  def update
    if @customer.update(customer_params)
      flash[:success] = "会員情報が更新されました。"
      redirect_to customers_path
    else
      flash.now[:warning] = '未記入項目があります'
      render :edit
    end
  end

  def check
  end

  def withdrawal
    @customer.update(is_deleted: true)
    reset_session
    flash[:error] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :nickname, :profile_image, :email, :is_deleted, :is_hidden)
  end
  
  def set_customer
    @customer = Customer.find(current_customer.id)
  end
  
  def ensure_guest_customer
    @customer = Customer.find(current_customer.id)
    if @customer.email == "guest@example.com"
      flash[:warning] = 'ゲストユーザーはこのページへ遷移できません。'
      redirect_to customers_path(current_customer)
    end
  end  
  
end
