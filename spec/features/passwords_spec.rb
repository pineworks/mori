require 'spec_helper'

describe "Password Management", :type => :feature do
  before(:each) do
    @user = create(:mori_minimal_user, :password => 'password123')
  end
  describe "Resetting your Password" do
    it "when you submit a forgotten password" do
      Mori::Mailer.should_receive(:password_reset_notification).exactly(1).times.and_call_original
      visit '/passwords/forgot'
      within "#forgot_password_form" do
        fill_in 'email', :with => @user.email
      end
      click_button "Reset Password"
      current_url.should eq send_reset_passwords_url
      page.has_content?('Password Reset Sent').should be true
    end
    it "shouldn't send a forgotten password for a user that doesn't exist" do
      visit '/passwords/forgot'
      within "#forgot_password_form" do
        fill_in 'email', :with => "imaemail@email.com"
      end
      click_button "Reset Password"
      page.has_content?('Forgot Password').should be true
    end
    it "should change a users password when they go to the link from the email" do
      Mori::User.forgot_password(@user.email)
      user = Mori::User.find_by_email(@user.email)
      visit "/passwords/reset?token=#{user.password_reset_token}"
      within ".edit_mori_user" do
        fill_in 'mori_user_password', :with => 'password123'
        fill_in 'mori_user_password_confirmation', :with => 'password123'
      end
      click_button "Update Password"
      page.current_path.should eq Mori.configuration.after_login_url
    end
  end
  describe "Changing your Password" do
    it "should chnage a users password" do
      new_pass = "potato"
      log_in(@user.email, 'password123')
      visit '/passwords/change'
      within "#password_change_form" do
        fill_in 'password', :with => 'password123'
        fill_in 'new_password', :with => new_pass
        fill_in 'new_password_confirmation', :with => new_pass
      end
      click_button "Change Password"
      ::BCrypt::Password.new(Mori::User.find(@user.id).password).should eq new_pass
      current_path.should eq Mori.configuration.after_password_change_url
    end
    it "should fail if the current password is not correct" do
      log_in(@user.email, 'password123')
      visit '/passwords/change'
      within "#password_change_form" do
        fill_in 'password', :with => 'passw123'
        fill_in 'new_password', :with => "pass"
        fill_in 'new_password_confirmation', :with => "pass"
      end
      click_button "Change Password"
      page.has_content?(I18n.t('flashes.password_change_failed')).should be true
    end
    it "should fail when the password confirmations don't match" do
      log_in(@user.email, 'password123')
      visit '/passwords/change'
      within "#password_change_form" do
        fill_in 'password', :with => 'password123'
        fill_in 'new_password', :with => 'potato'
        fill_in 'new_password_confirmation', :with => 'potatwo'
      end
      click_button "Change Password"
      page.has_content?(I18n.t('flashes.passwords_did_not_match')).should be true
    end
  end
  pending "Forgetting your password"
end
