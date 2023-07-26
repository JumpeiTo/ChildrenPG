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
    if @post.save
      flash[:success] = "投稿が作成されました"
      redirect_to posts_path
    else
      flash[:warning] = "未記入項目があります"
      flash.discard
      render :new
    end
  end

  def index
    # binding.pry
    # パラメーターで渡された並び替え条件が有効なものであればそれを使い、無効な場合はデフォルトの「新着順」を使う
    sort_by = %w[latest old rate_high rate_low likes_count_high likes_count_low comments_many comments_few].include?(params[:sort_by]) ? params[:sort_by] : "latest"
    # params形式だとエラーになるため変数に置き換える。params[:q]がない場合空のqを入れ込む
    param = params[:q] || {"title_or_text_or_playground_address_or_playground_name_or_playground_overview_cont"=>"", "playground_prefecture_eq"=>"", "rate_gteq"=>"", "rate_lteq"=>"", "post_target_ages_target_age_id_eq"=>"", "post_tags_tag_id_eq"=>""} 
    if param.is_a?(String)
      param =  JSON.parse(param, symbolize_names: true) # JSON形式の文字列をRubyのHash形式に変換
    end
    @q = Post.send(sort_by).ransack(param)
    @param = param
    # Ransackのクエリを適用して、非表示ユーザーの投稿を除外してページネーションで表示
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
    @ages = TargetAge.all
    @tags = Tag.all
    if @post.update(post_params)
      flash[:success] = "投稿が更新されました"
      redirect_to post_path(@post)
    else
      flash[:warning] = "未記入項目があります"
      flash.discard
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    flash[:error] = "投稿が削除されました"
    redirect_to customers_path(current_customer)
  end
  
  private

  def post_params
    params.require(:post).permit(:post_image, :customer_id, :playground_id, :title, :text, :playtime, :rate, target_age_ids: [], tag_ids: [])
  end
  
  def set_post
    @post = Post.find(params[:id]) 
  end
  
end
