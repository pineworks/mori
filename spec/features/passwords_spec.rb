require 'spec_helper'

describe "Password Management", :type => :feature do
  before(:each) do
    @user = create(:mori_minimal_user)
  end
  it "when you Resetting your password" do
    Mori::Mailer.should_receive(:forgot_password).exactly(1).times
    visit '/passwords/reset'
    within "#passwords_reset_form" do
      fill_in 'Email', :with => @user.email
    end
  end
  pending "Changing your password"
  pending "Forgetting your password"
end
