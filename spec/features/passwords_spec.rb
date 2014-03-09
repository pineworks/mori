require 'spec_helper'

describe "Password Management", :type => :feature do
  before(:each) do
    @user = create(:mori_minimal_user, :password => 'password123')
  end
  it "when you Resetting your password" do
    Mori::Mailer.should_receive(:password_reset_notification).exactly(1).times.and_call_original
    visit '/passwords/reset'
    within "#password_reset_form" do
      fill_in 'email', :with => @user.email
    end
    click_button "Reset Password"
    current_url.should eq send_reset_passwords_url
    page.has_content?('Password Reset Sent').should be true
  end
  it "shouldn't reset a password for a user that doesn't exist" do
    visit '/passwords/reset'
    within "#password_reset_form" do
      fill_in 'email', :with => "imaemail@email.com"
    end
    click_button "Reset Password"
    page.has_content?('Forgot Password').should be true
  end
  it "Changing your password" do
    log_in(@user.email, 'password123')
  end
  pending "Forgetting your password"
end
