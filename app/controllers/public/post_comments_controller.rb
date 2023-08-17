class Public::PostCommentsController < ApplicationController
  before_action :authenticate_customer!
  def create
    post = Post.find(params[:post_id])
    comment = current_customer.post_comments.new(post_comment_params)
    comment.post = post
    if comment.save
      flash[:success] = "コメントされました"
    else
      flash[:warning] = "コメントを入力してください"
    end
    redirect_to request.referer
  end

  def destroy
    PostComment.find(params[:id]).destroy
    flash[:error] = "コメントが削除されました"
    redirect_to post_path(params[:post_id])
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      flash[:success] = "コメントを編集しました"
      redirect_to @post
    else
      flash[:danger] = "編集に失敗しました"
      render "edit"
    end
  end

  private
    def post_comment_params
      params.require(:post_comment).permit(:comment)
    end
end
