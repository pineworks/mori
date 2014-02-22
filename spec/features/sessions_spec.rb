require 'spec_helper'

describe "Sessions controller", :type => :feature do
   let(:password){"password123"}
   before(:each) do
     @user = create(:mori_random_user, :password => "password123")
   end
   def log_in(pass)
     visit '/login'
     within '#new_session' do
       fill_in "Email", :with => @user.email
       fill_in "Password", :with => pass
     end
     page.find('#submit_button').click
   end
   it "should be able to log in" do
     log_in(password)
     current_path.should eq Mori.configuration.after_login_url
   end
   it "should redirect to the after login url if already logged in" do
     log_in(password)
     visit '/login'
     current_path.should eq Mori.configuration.after_login_url
   end
   it "should not log in with invalid credentials" do
     log_in('imapassword!')
     current_path.should eq '/sessions'
   end
   it "should be able to log out" do
     log_in(password)
     click_link 'Log Out'
     visit '/login'
     current_path.should eq '/login' 
   end
end
