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
    let(:user){ FactoryGirl.create(:user) }

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

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
    user = User.create :username => "Pekka", :password => "qweasd", :password_confirmation => "qweasd"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating 10, user

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with the highest rating if several rated" do
      create_beers_with_ratings 10, 20, 15, 7, 9, user
      best = create_beer_with_rating 25, user

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user) }

    it "has a method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      style = FactoryGirl.create(:style, :name => "Lager", :description => "")
      create_beer_with_rating_and_style 25, user, style

      expect(user.favorite_style).to eq(style)
    end

    it "is the one with the highest average rating if several beers rated" do
      style1 = FactoryGirl.create(:style, :name => "Lager", :description => "")
      style2 = FactoryGirl.create(:style, :name => "Porter", :description => "")
      create_beer_with_rating_and_style 10, user, style1
      create_beer_with_rating_and_style 15, user, style2
      create_beer_with_rating_and_style 16, user, style1

      expect(user.favorite_style).to eq(style2)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has a method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      brewery = FactoryGirl.create(:brewery, :name => "testbrewery", :year => "1921")
      create_beer_with_rating_and_brewery 25, user, brewery

      expect(user.favorite_brewery).to eq("testbrewery")
    end

    it "is the one with the highest average rating if several beers rated" do
      brewery1 = FactoryGirl.create(:brewery, :name => "Koff", :year => "1234")
      brewery2 = FactoryGirl.create(:brewery, :name => "Olvi", :year => "1234")
      create_beer_with_rating_and_brewery 10, user, brewery1
      create_beer_with_rating_and_brewery 20, user, brewery2
      create_beer_with_rating_and_brewery 50, user, brewery1

      expect(user.favorite_brewery).to eq("Koff")
    end
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, :score => score, :beer => beer, :user => user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating score, user
    end
  end

  def create_beer_with_rating_and_style(score, user, style)
    beer = FactoryGirl.create(:beer, :style => style)
    FactoryGirl.create(:rating, :score => score, :beer => beer, :user => user)
  end

  def create_beer_with_rating_and_brewery(score, user, brewery)
    beer = FactoryGirl.create(:beer, :brewery => brewery)
    FactoryGirl.create(:rating, :score => score, :beer => beer, :user => user)
  end
end

