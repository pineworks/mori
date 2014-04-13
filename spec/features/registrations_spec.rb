require 'spec_helper'

describe "The registration process", :type => :feature do
  it "should be able to register" do
    visit '/sign_up'
    within('#new_mori_user') do
      fill_in 'Email', :with => Faker::Internet.email
      fill_in 'Password', :with => "imapassword123"
    end
    click_button 'Sign Up'
    current_path.should eq Mori.configuration.after_signup_url
  end
  it "should redirect them if already signed up" do
    visit '/sign_up'
    within '#new_mori_user' do
      fill_in 'Email', :with => Faker::Internet.email
      fill_in 'Password', :with => 'password123'
    end
    click_button 'Sign Up'
    visit '/sign_up'
    current_path.should eq Mori.configuration.after_signup_url
  end
  it "should not allow invalid credentials" do
    visit '/sign_up'
    within('#new_mori_user') do
      fill_in 'Email', :with => "namenamename"
      fill_in 'Password', :with => "imapassword123"
    end
    click_button 'Sign Up'
    current_path.should eq '/registrations'
  end
end
