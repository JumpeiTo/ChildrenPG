class Public::PostsController < ApplicationController
  before_action :authenticate_customer!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def new
    @ages = TargetAge.all
    @tags = Tag.all
    @post = Post.new
    @post.playground_id = params[:playground_id] if params[:playground_id].present?
    @post.post_tags.build
    @post.post_target_ages.build
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    @ages = TargetAge.all
    @tags = Tag.all
    if @post.valid?
      if @post.save
        flash[:success] = "投稿が作成されました"
        redirect_to posts_path
      else
        flash[:warning] = "未記入項目があります"
        flash.discard
        render :new
      end
    else
      flash[:warning] = "投稿に失敗しました"
      flash.discard
      render :new
    end
  end

  def index
    # binding.pry
    # パラメーターで渡された並び替え条件が有効なものであればそれを使い、無効な場合はデフォルトの「新着順」を使います。
    sort_by = %w[latest old rate_high rate_low likes_count_high likes_count_low comments_many comments_few].include?(params[:sort_by]) ? params[:sort_by] : "latest"
    # 並び替えの条件に応じて適切なRansackのクエリを作成
    param = params[:q] # params形式だとエラーになるため変数に置き換える
    if param.is_a?(String)
      param =  JSON.parse(param, symbolize_names: true)
    end
    @q = Post.send(sort_by).ransack(param)
    @param = param
    # Ransackのクエリを適用して、非表示ユーザーの投稿を除外してページネーションで表示します。
    @posts = @q.result(distinct: true).joins(:customer).where(customers: { is_hidden: false }).page(params[:page]).per(10)
  end
  
  def show
    @playground = @post.playground
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.page(params[:page]).per(10)
    
    if @post.customer.is_hidden?
      @post_customer_nickname = "非公開ユーザー"
    elsif @post.customer.is_deleted?
      @post_customer_nickname = "退会済ユーザー"
    else
      @post_customer_nickname = @post.customer.nickname
    end
  end
  
  def edit
    @playground = @post.playground
    @ages = TargetAge.all
    @tags = Tag.all
  end
  
  def update
    if @post.update(post_params)
      flash[:success] = "投稿が更新されました"
      redirect_to post_path(@post)
    else
      flash[:warning] = "更新に失敗しました"
      flash.discard
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    flash[:error] = "投稿が削除されました"
    redirect_to posts_path
  end
  
  private

  def post_params
    params.require(:post).permit(:image, :customer_id, :playground_id, :title, :text, :playtime, :rate, target_age_ids: [], tag_ids: [])
  end
  
  def set_post
    @post = Post.find(params[:id]) 
  end
  
end
