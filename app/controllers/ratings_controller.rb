class RatingsController < ApplicationController

  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    Rating.create(rating_params)
    redirect_to ratings_path
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete
    redirect_to ratings_path
  end

  def rating_params
    params.require(:rating).permit(:beer_id, :score)
  end
end