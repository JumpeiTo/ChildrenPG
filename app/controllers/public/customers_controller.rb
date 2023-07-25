class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!, only: [:edit, :update, :withdrawal]
  before_action :set_customer, except: [:check]
  before_action :ensure_guest_customer, only: [:edit, :withdrawal]
  before_action :set_sort_by, only: [:show, :favorites, :comments]
  
  def show
    # 並び替えの条件は @sort_by 変数によって決まる
    @posts = @customer.posts.public_send(@sort_by).page(params[:page]).per(10)
  end
  
  def favorites
    # ユーザーがいいねした投稿のIDを取得して、指定された並び順で表示
    favorite_post_ids = @customer.post_favorites.pluck(:post_id)
    @favorite_posts = Post.where(id: favorite_post_ids).joins(:customer).where(customers: { is_hidden: false }).public_send(@sort_by).page(params[:page]).per(10)
  end

  def comments
    # ユーザーがコメントした投稿のIDを取得して、指定された並び順で表示
    comments_post_ids = @customer.post_comments.pluck(:post_id)
    @comment_posts = Post.where(id: comments_post_ids).joins(:customer).where(customers: { is_hidden: false }).public_send(@sort_by).page(params[:page]).per(10)
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
    # 会員退会処理を行うためのアクション
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
    # customer_idがない場合はcurrent_customer.idをいれる
    @customer = params[:customer_id].present? ? Customer.find(params[:customer_id]) : Customer.find(current_customer.id)
  end
  
  def ensure_guest_customer
    # ゲストユーザーかどうかを確認し、ゲストユーザーの場合は特定のページへリダイレクト
    @customer = Customer.find(current_customer.id)
    if @customer.email == "guest@example.com"
      flash[:warning] = 'ゲストユーザーはこのページへ遷移できません。'
      redirect_to customers_path(current_customer)
    end
  end

  def set_sort_by
    # 並び替えの条件を決定するためのメソッド
    # パラメーターで渡された並び替え条件が有効なものであればそれを使い、無効な場合はデフォルトの「新着順」を使う
    sort_by = params[:sort_by]
    @sort_by = %w[latest old rate_high rate_low likes_count_high likes_count_low comments_many comments_few].include?(sort_by) ? sort_by : "latest"
  end
end
