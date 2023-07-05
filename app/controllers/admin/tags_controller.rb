class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_tag, only: [:edit, :update, :destroy]
  
  def index
    @tag = Tag.new
    @tags = Tag.all
  end
  
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:success] = "タグが作成されました。"
      redirect_to admin_tags_path
    else
      @tags = Tag.all
      flash[:warning] = "未記入項目があります"
      flash.discard
      render :index
    end
  end

  def edit
  end
  
  def update
    if @tag.update(tag_params)
      flash[:success] = "タグが更新されました。"
      redirect_to admin_tags_path
    else
      flash[:warning] = "未記入項目があります"
      flash.discard
      render :edit
    end
  end
  
  def destroy
    @tag.destroy
    flash[:error] = "タグが削除されました。"
    redirect_to admin_tags_path
  end
  
  private

  def tag_params
    params.require(:tag).permit(:name)
  end
  
  def set_tag
    @tag = Tag.find(params[:id])
  end
  
end
