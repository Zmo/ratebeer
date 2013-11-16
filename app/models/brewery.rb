class Brewery < ActiveRecord::Base
  include AverageRating

  validates_length_of :name, :minimum => 1
  validates :year, numericality: { only_integer: true, greater_than: 1042 }
  validate :year_is_not_in_the_future

  def year_is_not_in_the_future
    if Time.now.year < year
      errors.add(:year, "can't be in the future")
    end
  end

  has_many :beers
  has_many :ratings, :through => :beers
end
