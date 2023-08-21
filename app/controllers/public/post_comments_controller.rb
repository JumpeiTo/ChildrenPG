class Public::PostCommentsController < ApplicationController
  before_action :authenticate_customer!
  def create
    post = Post.find(params[:post_id])
    @comment = current_customer.post_comments.new(post_comment_params)
    @comment.post_id = post.id
    if @comment.save
      # flash[:success] = "コメントされました"
    else
      # flash[:warning] = "コメントを入力してください"
    end
  end

  def destroy
    @comment = PostComment.find(params[:id])
    post = @comment.post
    @comment.destroy
    # flash[:error] = "コメントが削除されました"
  end

  private
    def post_comment_params
      params.require(:post_comment).permit(:comment)
    end
end
