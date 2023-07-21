class Public::PlaygroundsController < ApplicationController
  def create
    @playground = Playground.find_or_initialize_by(place_id: playground_params[:place_id])

    unless @playground.persisted?
      input_categories = params[:playground][:category].split(",")
      @playground.assign_attributes(playground_params)
      @playground.categories = Category.where(name: input_categories)
      @playground.create_categories(input_categories) # メソッド呼び出し
      @playground.save
    end
    redirect_to new_post_path(playground_id: @playground.id)
  end
  
  def show
    @playground = Playground.find(params[:id])
    # 公開ユーザーのみ表示
    @q =  @playground.post.ransack(params[:q])
    @posts = @q.result(distinct: true).joins(:customer).where(customers: { is_hidden: false }).page(params[:page]).per(10)
  end

  private

  def playground_params
    params.require(:playground).permit(:place_id, :latitude, :longitude, :name, :overview, :icon, :postal_code, :address, :prefecture, :rate, :open_now, :business_hours, :website, :phone_number, :photo_url)
  end
end
