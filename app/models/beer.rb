class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings, :dependent => :destroy

  def average_rating
    ratings.inject(0) { |result, element| result + element.score } / ratings.size
    #sum = 0
    #ratings.each do |rating|
    #  sum = sum + rating.score
    #end
    #sum = sum / ratings.size
    #return sum
  end

  def to_s
    name + " - " + brewery.name
  end
end
