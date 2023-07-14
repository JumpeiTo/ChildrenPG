class Public::PostFavoritesController < ApplicationController
  before_action :set_post

  def create
    @post_favorite = PostFavorite.new(customer_id: current_customer.id, post_id: @post.id)
    @post_favorite.save
  end

  def destroy
    @post_favorite = PostFavorite.find_by(customer_id: current_customer.id, post_id: @post.id)
    @post_favorite.destroy
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
  end
end
