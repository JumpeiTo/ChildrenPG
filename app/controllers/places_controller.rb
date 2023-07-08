class PlacesController < ApplicationController
  # キーワードで検索（typeは指定済）
  def keyword_search
    Dotenv.load
    client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    @keyword = params[:keyword]
    if @keyword.present?
      type_option
      @places = client.spots_by_query(@keyword, query_options)
    else
      type_option
      @places = client.spots_by_query("",query_options)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # 絞り込んで検索
  def search
    Dotenv.load
    client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    @name = params[:name]
    @types = params[:types]
    @radius = params[:radius]
    @lat = params[:lat]
    @lng = params[:lng]

    if @types.present? || @radius.present? || @name.present?
      query_options = build_query_search_options(@types, @radius, @name)
      @places = client.spots(@lat, @lng, query_options)
    else
      @places = []
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  # キーワード検索用オプション
  def build_query_keyword_options(types)
    options = { language: 'ja' }
    options[:types] = types if types.present?
    options
  end
  
  def type_option
    query_options = build_query_keyword_options(['park', 'tourist_attraction', 'amusement_park', 'airport', 'aquarium', 'art_gallery', 'book_store', 'bowling_alley', 'cafe', 'campground', 'department_store', 'hardware_store', 'library', 'movie_theater', 'museum', 'pet_store', 'school', 'restaurant', 'shopping_mall', 'stadium', 'store', ''])
  end

  # 絞り込み検索用オプション
  def build_query_search_options(types, radius, name)
    options = { language: 'ja' }
    options[:name] = name if name.present?
    options[:types] = types if types.present?
    options[:radius] = radius.present? ? radius : 20000
    options
  end

end
