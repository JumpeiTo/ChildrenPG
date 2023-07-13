class Public::PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit]
  
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
    @posts = Post.all
  end
  
  def show
    @playground =  @post.playground
  end
  
  private

  def post_params
    params.require(:post).permit(:image,:customer_id, :playground_id, :title, :text, :playtime, :rate, target_age_ids: [], tag_ids: [])
  end
  
  def set_post
    @post = Post.find(params[:id]) 
  end
end
