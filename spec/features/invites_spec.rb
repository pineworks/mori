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
    end
    it "should send an invite" do
    end
  end
end
