require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new :username => "Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a proper password" do
    user = User.create :username => "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ User.create :username => "Pekka", :password => "secret1", :password_confirmation => "secret1" }

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new :score => 10
      rating2 = Rating.new :score => 20

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating user.ratings).to eq(15.0)
    end
    
    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end
  end

  it "is not saved with a password that is too short" do
    user = User.create :username => "Pekka", :password => "a1", :password_confirmation => "a1"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a password with only letters" do
    user = User.create :username => "Pekka", :password => "qwerty", :password_confirmation => "qwerty"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end
end

