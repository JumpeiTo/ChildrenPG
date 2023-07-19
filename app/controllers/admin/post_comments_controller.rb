class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:customer_id]
      @customer = Customer.find(params[:customer_id])
      @q =@customer.post_comments.ransack(params[:q])
      @post_comments = @q.result(distinct: true).page(params[:page]).per(10)
    elsif params[:post_id]
      @post = Post.find(params[:post_id])
      @q =@post.post_comments.ransack(params[:q])
      @post_comments = @q.result(distinct: true).page(params[:page]).per(10)
    else
      @q =PostComment.ransack(params[:q])
      @post_comments = @q.result(distinct: true).page(params[:page]).per(10)
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
