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
    sort_by = params[:sort_by]
    # sort_byが指定されていない場合、デフォルト値として"latest"（新着順）を設定する
    sort_by = "latest" unless %w[latest old rate_high rate_low likes_count_high likes_count_low comments_many comments_few].include?(sort_by)
    # 指定されたsort_byに応じて投稿を並び替えて取得し、非表示のカスタマーを除外して表示する
    @posts = @playground.post.public_send(sort_by).joins(:customer).where(customers: { is_hidden: false }).page(params[:page]).per(10)
  end

  private

  def playground_params
    params.require(:playground).permit(:place_id, :latitude, :longitude, :name, :overview, :icon, :postal_code, :address, :prefecture, :rate, :open_now, :business_hours, :website, :phone_number, :photo_url)
  end
end
