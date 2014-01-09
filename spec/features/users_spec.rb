require 'spec_helper'

describe "User" do
  include OwnTestHelper

  before :each do
    FactoryGirl.create :brewery, :name => "Koff"
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can sign in with right credentials" do
      sign_in 'Pekka', 'foobar1'

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to sign in form if wrong credentials given" do
      visit signin_path
      fill_in('username', :with => 'Pekka')
      fill_in('password', :with => 'wrong')
      click_button('Log in')

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and password do not match'
    end

    it "with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', :with => 'Brian')
      fill_in('user_password', :with => 'secret55')
      fill_in('user_password_confirmation', :with => 'secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "can add a beer" do
      sign_in 'Pekka', 'foobar1'
      visit beers_path
      click_link "New Beer"
      fill_in('Name', :with => 'testbeer')
      select('Weizen', :from => 'Style')
      select('Koff', :from => 'beer[brewery_id]')
      expect{
        click_button "Create Beer"
      }.to change{Beer.count}.from(0).to(1)
      expect(page).to have_content 'testbeer'
    end
  end
end
