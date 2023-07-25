class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  
  def index
    if params[:customer_id]
      @customer = Customer.find(params[:customer_id])
      @q = @customer.posts.ransack(params[:q])
      @posts = @q.result(distinct: true).page(params[:page]).per(10)
      else
      @q = Post.ransack(params[:q])
      @posts = @q.result(distinct: true).page(params[:page]).per(10)
    end
  end
  
  def show
  end
  
  def edit
    @ages = TargetAge.all
    @tags = Tag.all
  end
  
  def update
    if @post.update(post_params)
      flash[:success] = "投稿が更新されました。"
      redirect_to admin_post_path(params[:id])
    else 
      flash.now[:warning] = '未記入項目があります'
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    flash[:error] = "投稿が削除されました"
    redirect_to request.referer
  end
  
  private
  
  def post_params
    params.require(:post).permit(:post_image, :customer_id, :playground_id, :title, :text, :playtime, :rate, target_age_ids: [], tag_ids: [])
  end
  
  def set_post
    @post = Post.find(params[:id]) 
  end
end
