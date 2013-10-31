class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    ratings.inject(0) { |result, element| result + element.score } / ratings.size
    #sum = 0
    #ratings.each do |rating|
    #  sum = sum + rating.score
    #end
    #sum = sum / ratings.size
    #return sum
  end
end
