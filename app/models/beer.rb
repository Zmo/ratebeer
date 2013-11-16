class Beer < ActiveRecord::Base
  include AverageRating

  validates_length_of :name, :minimum => 1

  belongs_to :brewery
  has_many :ratings, :dependent => :destroy
  has_many :raters, :through => :ratings, :source => :user

  #def average_rating
    #ratings.inject(0) { |result, element| result + element.score } / ratings.size
    #sum = 0
    #ratings.each do |rating|
    #  sum = sum + rating.score
    #end
    #sum = sum / ratings.size
    #return sum
  #end

  def to_s
    name + " - " + brewery.name
  end
end
