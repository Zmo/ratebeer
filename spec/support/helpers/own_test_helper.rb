module OwnTestHelper
  def sign_in(username, password)
    visit signin_path
    fill_in('username', :with => 'Pekka')
    fill_in('password', :with => 'foobar1')
    click_button('Log in')
  end
end
