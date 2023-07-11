class Public::PlaygroundsController < ApplicationController
  def create
    @playground = Playground.find_or_initialize_by(place_id: playground_params[:place_id])

    if @playground.new_record?
        input_categories = params[:playground][:category].split(",")
        @playground.categories = Category.where(name: input_categories)
        @playground.create_categories(input_categories)
        @playground.place_id = playground_params[:place_id]
        @playground.latitude = playground_params[:latitude]
        @playground.longitude = playground_params[:longitude]
        @playground.name = playground_params[:name]
        @playground.overview = playground_params[:overview]
        @playground.icon = playground_params[:icon]
        @playground.postal_code = playground_params[:postal_code]
        @playground.address = playground_params[:address]
        @playground.prefecture = playground_params[:prefecture]
        @playground.rate = playground_params[:rate]
        @playground.open_now = playground_params[:open_now]
        @playground.business_hours = playground_params[:business_hours]
        @playground.website = playground_params[:website]
        @playground.phone_number = playground_params[:phone_number]
        @playground.photo_url = playground_params[:photo_url]
        @playground.save
    end
    redirect_to new_post_path(playground_id: @playground.id)
  end

  private

  def playground_params
    params.require(:playground).permit(:place_id, :latitude, :longitude, :name, :overview, :icon, :postal_code, :address, :prefecture, :rate, :open_now, :business_hours, :website, :phone_number, :photo_url)
  end
  
  def category_params
    params.require(:playground).permit(:name)
  end
end
