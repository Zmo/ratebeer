class PlacesController < ApplicationController
  def index

  end

  def show
    places = Rails.cache.read session[:city]
    @place = places[places.find_index { |place| place.id == params[:id] } ]
    @scores = BeermappingAPI.place_scores @place.id
    render :show
  end

  def search
    @places = BeermappingAPI.places_in(params[:city])
    session[:city] = params[:city]
    if @places.empty?
      redirect_to places_path, :notice => "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
