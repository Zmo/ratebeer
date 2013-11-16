module AverageRating
  def average_rating(ratings)
    unless ratings.empty?
      ratings.inject(0) { |result, element| result + element.score } / ratings.size
    else
      return 0
    end
  end
end
