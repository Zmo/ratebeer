class Style < ActiveRecord::Base
  include AverageRating

  has_many :beers
end
