class Brewery < ActiveRecord::Base
  has_many :beers
  has_many :ratings, :through => :beers

  def average_rating
    ratings.inject(0) { |result, element| result + element.score } / ratings.size
  end
end
