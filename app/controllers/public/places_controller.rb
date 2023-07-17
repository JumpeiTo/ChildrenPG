class Public::PlacesController < ApplicationController
  def search
    Dotenv.load
    client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    @name = params[:name]
    @types = params[:types]
    @radius = params[:radius]
    @lat = params[:lat]
    @lng = params[:lng]
    
    if coordinate_present?
      query_options = build_query_options
       @places = client.spots(@lat, @lng, query_options)
    else
      if @name.present?
        query_options = build_query_keyword_options
        @places = client.spots_by_query(@name, query_options)
      else
        query_options = build_query_keyword_options
        @places = client.spots_by_query(@name, query_options)
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

 def detailed_search
    Dotenv.load
    client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    place_id = params[:place_id]
    # Playgroundに一致するplace_idがあるか検索
    playground = Playground.find_by(place_id: place_id)
    if playground.present?
      # 一致するPlaygroundが存在する場合は、それを使用
      redirect_to playground_path(playground)
    else
      # 一致するPlaygroundが存在しない場合は、Google Places APIを使用して情報を取得
      @place = client.spot(place_id, language: 'ja')
    end
  end


  private

  # 緯度経度検索オプションの構築
  def build_query_options
    options = { language: 'ja' }
    if @name.present?
      options[:name] = @name
    end
    if @types.present?
      options[:types] = @types
    end
    if @radius.present?
      options[:radius] = @radius
    else
      options[:radius] = 50000
    end
    options
  end
  
    # キーワード検索用オプション
  def build_query_keyword_options
    options = { language: 'ja' }
    if @name.present?
      if @types.present?
        options[:types] = @types
      end
    else
      if @types.present?
        options[:types] = @types
      else
        options[:types] = 'amusement_park'
      end
    end
    options
  end
  
  # 緯度経度の有無をチェックするヘルパーメソッド
  def coordinate_present?
    @lat != ""
  end
end
