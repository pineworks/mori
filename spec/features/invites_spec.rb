require 'spec_helper'

describe "Inviting Users", :type => :feature do
  before(:each) do
    @user = create(:mori_minimal_user, :password => 'password123')
  end
  describe "Sending an invite" do
    it "should require you to be logged in" do
      visit "/invites/new"
      page.has_content?('Log In').should be true
    end
    it "should not invite a user that already exists" do
      log_in(@user.email, 'password123')
      visit "/invites/new"
      within(:css, "#invite_new_user_form") do
        fill_in "E-mail", :with => @user.email
        click_button "Invite User"
      end
      page.has_content?(I18n.t('flashes.could_not_invite_user')).should be true
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
end
