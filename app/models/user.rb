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

  has_many :ratings
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :beer_clubs, :through => :memberships
end
