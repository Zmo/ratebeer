require 'spec_helper'

describe "Rating" do
  include OwnTestHelper

  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, :name => "iso 3", :brewery => brewery }
  let!(:beer2) { FactoryGirl.create :beer, :name => "Karhu", :brewery => brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in 'Pekka', 'foobar1'
  end
  
  describe "when user has signed in and a rating is given" do
    before :each do
      visit new_rating_path
      select(beer1.to_s, :from => 'rating[beer_id]')
      fill_in('rating[score]', :with => '15')
    end
      
    it "it is registered to the beer and user who is signed in" do
      expect{
        click_button "Create Rating"
      }.to change{Rating.count}.from(0).to(1)

      expect(user.ratings.count).to eq(1)
      expect(beer1.ratings.count).to eq(1)
      expect(beer1.average_rating beer1.ratings).to eq(15.0)
    end

    it "it is listed on the users page" do 
      click_button "Create Rating"
      visit user_path(user.id)

      expect(page).to have_content 'iso 3 15'
    end

    it "and it is removed it is deleted from the database" do
      click_button "Create Rating"
      visit user_path(user.id)
      expect{
        first(:link, "Delete").click
      }.to change{Rating.count}.from(1).to(0)
    end
  end

  it "when submitted is shown on the ratings page" do
    FactoryGirl.create(:rating, :score => 25, :beer => beer1, :user => user)
    visit ratings_path

    expect(page).to have_content "iso 3 25, rated by Pekka"
  end
end
