class Public::PlaygroundsController < ApplicationController
  def create
    @playground = Playground.find_or_initialize_by(place_id: playground_params[:place_id])

    unless @playground.persisted?
      input_categories = params[:playground][:category].split(",")
      @playground.assign_attributes(playground_params)
      @playground.categories = Category.where(name: input_categories)
      @playground.create_categories(input_categories)
      @playground.save
    end

    redirect_to new_post_path(playground_id: @playground.id)
  end

  private

  def playground_params
    params.require(:playground).permit(:place_id, :latitude, :longitude, :name, :overview, :icon, :postal_code, :address, :prefecture, :rate, :open_now, :business_hours, :website, :phone_number, :photo_url)
  end
end
