class PlacesController < ApplicationController
  # キーワードで検索（typeは指定済）
  def keyword_search
    Dotenv.load
    client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    @keyword = params[:keyword]
    if @keyword.present?
      query_options = build_query_keyword_options(type_option)
      @places = client.spots_by_query(@keyword, query_options)
    else
      query_options = build_query_keyword_options(type_option)
      @places = client.spots_by_query("", query_options)
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
    
    if @types.present?
      query_options = build_query_search_options(@types, @radius, @name)
    elsif @radius.present? || @name.present?
      query_options = build_query_search_options(type_option, @radius, @name)
    else @radius.present? || @name.present?
      query_options = build_query_search_options(type_option, @radius, nil)
    end
    @places = client.spots(@lat, @lng, query_options)

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def detailed_search
    Dotenv.load
    client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    place_id = params[:place_id]
    @place = client.spot(place_id, :language => 'ja')
  end

  private

  # キーワード検索用オプション
  def build_query_keyword_options(types)
    options = { language: 'ja' }
    options[:types] = types if types.present?
    options
  end
  
  # タイプ指定
  def type_option
    ['amusement_park', 'aquarium', 'zoo', 'park', 'tourist_attraction', 'airport', 'art_gallery', 'book_store', 'bowling_alley', 'campground', 'department_store', 'library', 'movie_theater', 'museum', 'pet_store', 'school', 'restaurant', 'shopping_mall', 'stadium', 'store']
  end

  # 絞り込み検索用オプション
  def build_query_search_options(types, radius, name)
    options = { language: 'ja' }
    if name.present?
      options[:name] = name
    end
    options[:types] = types if types.present?
    options[:radius] = radius.present? ? radius : 20000
    options
  end

end
