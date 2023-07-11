class Public::PostsController < ApplicationController
  def new
    @ages = TargetAge.all
    @tags = Tag.all
    @post = Post.new
    @post.customer_id = current_customer.id
    @post.playground_id = params[:playground_id]
    @post.post_tags.build
  end

  def create
    @post = Post.new(post_params)
    if @post.valid?
      if @post.save
        flash[:success] = "投稿が作成されました"
        redirect_to root_path
      else
        flash[:warning] = "未記入項目があります"
        flash.discard
        render :new
      end
    else
      flash[:warning] = "投稿に失敗しました"
      flash.discard
      render 'new'
    end
  end

  private

  def post_params
    params.require(:post).permit(:image,:customer_id, :playground_id, :title, :text, :playtime, :rate, target_age_ids: [], tag_ids: [])
  end
end
