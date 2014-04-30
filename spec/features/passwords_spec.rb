require 'spec_helper'

describe 'Password Management', :type => :feature do
  before(:each) do
    @user = create(:mori_minimal_user, :password => 'password123')
  end
  describe 'Resetting/Forgetting your Password' do
    it 'when you submit a forgotten password' do
      MoriMailer.should_receive(:forgot_password).exactly(1).times.and_call_original
      visit '/passwords/forgot'
      within '#forgot_password_form' do
        fill_in 'email', :with => @user.email
      end
      click_button 'Reset Password'
      current_url.should eq send_reset_passwords_url
      page.has_content?('Password Reset Sent').should be true
    end
    it 'shouldn\'t send a forgotten password for a user that doesn\'t exist' do
      visit '/passwords/forgot'
      within '#forgot_password_form' do
        fill_in 'email', :with => 'imaemail@email.com'
      end
      click_button 'Reset Password'
      page.has_content?('Reset My Password').should be true
    end
    it 'should change a users password when they go to the link from the email' do
      Mori.configuration.user_model.forgot_password(@user.email)
      user = Mori.configuration.user_model.find_by_email(@user.email)
      visit "/passwords/reset?token=#{user.password_reset_token}"
      within '.edit_user' do
        fill_in 'user_password', :with => 'password123'
        fill_in 'user_password_confirmation', :with => 'password123'
      end
      click_button 'Update Password'
      page.current_path.should eq Mori.configuration.dashboard_path
    end
    it 'should render the reset form again if the change failed' do
      Timecop.freeze(Date.today - 3.weeks) do
        Mori.configuration.user_model.forgot_password(@user.email)
      end
      user = Mori.configuration.user_model.find_by_email(@user.email)
      visit "/passwords/reset?token=#{user.password_reset_token}"
      within '.edit_user' do
        fill_in 'user_password', :with => 'password123'
        fill_in 'user_password_confirmation', :with => 'password123'
      end
      click_button 'Update Password'
      page.has_content?('Expired Reset Token').should be true
    end
    it 'should redirect if no user is found' do
      visit '/passwords/reset?token=123asdf123'
      page.current_path.should eq root_path
    end
  end
  describe 'Changing your Password' do
    it 'should require you to be logged in' do
      visit '/passwords/change'
      page.has_content?('Log In').should be true
    end
    it 'should change a users password' do
      new_pass = 'potato'
      log_in(@user.email, 'password123')
      visit '/passwords/change'
      within '#password_change_form' do
        fill_in 'password', :with => 'password123'
        fill_in 'new_password', :with => new_pass
        fill_in 'new_password_confirmation', :with => new_pass
      end
      click_button 'Change Password'
      ::BCrypt::Password.new(Mori.configuration.user_model.find(@user.id).password).should eq new_pass
      current_path.should eq Mori.configuration.dashboard_path
    end
    it 'should fail if the current password is not correct' do
      log_in(@user.email, 'password123')
      visit '/passwords/change'
      within '#password_change_form' do
        fill_in 'password', :with => 'passw123'
        fill_in 'new_password', :with => 'pass'
        fill_in 'new_password_confirmation', :with => 'pass'
      end
      click_button 'Change Password'
      page.has_content?(I18n.t('flashes.password_change_failed')).should be true
    end
    it 'should fail when the password confirmations don\'t match' do
      log_in(@user.email, 'password123')
      visit '/passwords/change'
      within '#password_change_form' do
        fill_in 'password', :with => 'password123'
        fill_in 'new_password', :with => 'potato'
        fill_in 'new_password_confirmation', :with => 'potatwo'
      end
      click_button 'Change Password'
      page.has_content?(I18n.t('flashes.passwords_did_not_match')).should be true
    end
  end
end
