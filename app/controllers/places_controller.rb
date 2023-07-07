class PlacesController < ApplicationController
  def search
    Dotenv.load
    client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    @keyword = params[:keyword]
    query_options = build_query_options(['park', 'tourist_attraction','amusement_park','airport','aquarium','art_gallery','book_store','bowling_alley','cafe','campground','department_store','hardware_store','library','movie_theater','museum','pet_store','school','restaurant','shopping_mall','stadium','store','zoo'])
    @places = client.spots_by_query(@keyword, query_options)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def build_query_options(types)
    options = { language: 'ja' }
    options[:types] = types if types.present?
    options
  end
end
