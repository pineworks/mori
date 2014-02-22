require 'spec_helper'

describe "The registration process", :type => :feature do
  it "should be able to register" do
    visit '/sign_up'
    within('#new_mori_user') do
      fill_in 'Email', :with => Faker::Internet.email
      fill_in 'Password', :with => "imapassword123"
    end
    click_button 'Create User'
    current_path.should eq Mori.configuration.after_signup_url
  end
  it "should redirect them if already signed up" do
    visit '/sign_up'
    within '#new_mori_user' do
      fill_in 'Email', :with => Faker::Internet.email
      fill_in 'Password', :with => 'password123'
    end
    click_button 'Create User'
    visit '/sign_up'
    current_path.should eq Mori.configuration.after_signup_url
  end
end
