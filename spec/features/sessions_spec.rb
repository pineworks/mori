require 'spec_helper'

describe "Sessions controller", :type => :feature do
   let(:password){"password123"}
   before :each  do
     @user = create(:mori_random_user, :password => "password123")
   end
   it "should be able to log in" do
     log_in(@user.email, password)
     current_path.should eq Mori.configuration.after_login_url
   end
   it "should redirect to the after login url if already logged in" do
     log_in(@user.email, password)
     visit '/login'
     current_path.should eq Mori.configuration.after_login_url
   end
   it "should not log in with invalid credentials" do
     log_in(@user.email, 'imapassword!')
     current_path.should eq '/sessions'
   end
   it "should be able to log out" do
     log_in(@user.email, password)
     click_link 'Log Out'
     visit '/login'
     current_path.should eq '/login'
   end
end
