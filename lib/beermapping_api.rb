class BeermappingAPI

  def self.places_in(city)
    Place
    city = city.downcase
    Rails.cache.write city, fetch_places_in(city), expires_in: 60.minutes if not Rails.cache.exist? city

    Rails.cache.read city
  end

  def self.place_scores(place_id)
    Place
    response = HTTParty.get "http://beermapping.com/webservice/locscore/#{key}/#{place_id}/"
    response.parsed_response["bmp_locations"]["location"]
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    return places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.key
    Settings.beermapping_apikey
  end
end
