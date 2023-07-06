require 'google_places'

class PlacesController < ApplicationController
  def search
    client = GooglePlaces::Client.new(ENV['GOOGLE_PLACES_API_KEY'])
    @keyword = params[:keyword]
    @places = client.spots_by_query(@keyword)

    respond_to do |format|
      format.js
    end
  end
end
