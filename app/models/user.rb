class User < ActiveRecord::Base
  include AverageRating

  has_secure_password

  validates_uniqueness_of :username
  validates_length_of :username, :minimum => 3, :maximum => 15
  validates_length_of :password, :minimum => 4
  validate :password_must_contain_atleast_one_number

  def password_must_contain_atleast_one_number
    if not /[a-zA-Z]*[1-9]+[a-zA-Z]*/.match(password)
      errors.add(:password, "must contain atleast one number")
    end
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def favorite_style
    return nil if ratings.empty?
    styles = ratings.map { |r| r.beer.style }.uniq
    styles.max_by do |style|
      ratingstyles = ratings.find_all { |r| r.beer.style == style }
      num = ratingstyles.count
      sum = ratingstyles.reduce(0) { |acc, r| acc + r.score }
      sum/num
    end
  end

  def favorite_brewery
    return nil if ratings.empty?
    brewerys = ratings.map { |r| r.beer.brewery.name }.uniq
    brewerys.max_by do |brewery|
      ratingstyles = ratings.find_all { |r| r.beer.brewery.name == brewery }
      num = ratingstyles.count
      sum = ratingstyles.reduce(0) { |acc, r| acc + r.score }
      sum/num
    end
  end

  has_many :ratings
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :beer_clubs, :through => :memberships
end
