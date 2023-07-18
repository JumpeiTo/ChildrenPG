class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:customer_id]
      @customer = Customer.find(params[:customer_id])
      @post_comments = @customer.post_comments.page(params[:page]).per(10)
    elsif params[:post_id]
      @post = Post.find(params[:post_id])
      @post_comments = @post.post_comments.page(params[:page]).per(10)
    else
      @post_comments = PostComment.page(params[:page]).per(10)
    end
  end
  
  def destroy
    PostComment.find(params[:id]).destroy
    flash[:error] = "コメントが削除されました"
    redirect_to request.referer
  end 

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
