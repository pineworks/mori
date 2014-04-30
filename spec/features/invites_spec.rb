require 'spec_helper'

describe 'Inviting Users', :type => :feature do
  before(:each) do
    @user = create(:mori_minimal_user, :password => 'password123')
  end
  describe 'Sending an invite' do
    it 'should require you to be logged in' do
      visit '/invites/new'
      page.has_content?('Log In').should eq true
    end
    it 'should not invite a user that already exists' do
      log_in(@user.email, 'password123')
      visit '/invites/new'
      within(:css, '#invite_new_user_form') do
        fill_in 'E-mail', :with => @user.email
        click_button 'Invite User'
      end
      page.has_content?(I18n.t('flashes.could_not_invite_user')).should eq true
    end
    it 'should send an invite' do
      log_in(@user.email, 'password123')
      visit '/invites/new'
      MoriMailer.should_receive(:invite_user).exactly(1).times
      within(:css, '#invite_new_user_form') do
        fill_in 'E-mail', :with => 'imanewemail@email.com'
        click_button 'Invite User'
      end
      page.current_path.should eq Mori.configuration.dashboard_path
    end
  end
  describe 'Accepting an invite' do
    before(:each) do
      _valid, message = Mori.configuration.user_model.invite('new_email@email.com')
      @user = User.find_by_email('new_email@email.com')
    end
    it 'should redirect to the homepage if the invite token is not found' do
      visit '/invites/asd234fdsasd234'
      page.current_path.should eq root_path
    end
    it 'should redirect to the invites path if validation fails' do
      visit "/invites/#{@user.invitation_token}"
      User.should_receive(:accept_invitation).exactly(1).times.and_call_original
      within(:css, '.edit_user') do
        fill_in 'Password', :with => 'passwoasdfasdfasdasdf'
        fill_in 'Password confirmation', :with => 'password123'
      end
      click_button 'Accept'
      page.current_path.should eq "/invites/#{@user.invitation_token}"
      page.has_content?(I18n.t('flashes.passwords_dont_match')).should eq true
    end
    it 'should accept the invite and log the new user in' do
      visit "/invites/#{@user.invitation_token}"
      User.should_receive(:accept_invitation).exactly(1).times.and_call_original
      within(:css, '.edit_user') do
        fill_in 'Password', :with => 'password123'
        fill_in 'Password confirmation', :with => 'password123'
      end
      click_button 'Accept'
      page.current_path.should eq Mori.configuration.dashboard_path
      page.has_content?(I18n.t('flashes.logged_in')).should be true
    end
  end
end
