require 'spec_helper'

describe "Inviting Users", :type => :feature do
  before(:each) do
    @user = create(:mori_minimal_user, :password => 'password123')
  end
  describe "Sending an invite" do
    it "should require you to be logged in" do
      visit "/invites/new"
      page.has_content?('Log In').should eq true
    end
    it "should not invite a user that already exists" do
      log_in(@user.email, 'password123')
      visit "/invites/new"
      within(:css, "#invite_new_user_form") do
        fill_in "E-mail", :with => @user.email
        click_button "Invite User"
      end
      page.has_content?(I18n.t('flashes.could_not_invite_user')).should eq true
    end
    it "should send an invite" do
      log_in(@user.email, 'password123')
      visit "/invites/new"
      Mori::Mailer.should_receive(:invite_user).exactly(1).times
      within(:css, "#invite_new_user_form") do
        fill_in "E-mail", :with => "imanewemail@email.com"
        click_button "Invite User"
      end
      page.current_path.should eq Mori.configuration.after_invite_url
    end
  end
  describe "Accepting an invite" do
    before(:each) do
      valid, @invited = Mori::User.invite('new_email@email.com')
    end
    it "should redirect to the homepage if the invite token is not found" do
      visit "/invites/asd234fdsasd234"
      page.current_path.should eq root_path
    end
    it "should accept the invite and log the new user in" do
      visit "/invites/#{@invited.invitation_token}"
      Mori::User.should_receive(:accept_invitation).exactly(1).times.and_call_original
      within(:css, ".edit_mori_user") do
        fill_in "Password", :with => "password123"
        fill_in "Password confirmation", :with => "password123"
      end
      click_button "Accept"
      page.current_path.should eq Mori.configuration.dashboard_path
      page.has_content?(I18n.t('flashes.logged_in')).should be true
    end
  end
end
