class Public::PostsController < ApplicationController
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
    @posts = Post.all
  end
  
  def show
    @playground = @post.playground
    @post_comment = PostComment.new
    
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
