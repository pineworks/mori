require 'spec_helper'
describe MoriHelper do
  it "should return the logout link" do
    logout_link.should eq link_to('Log Out', '/logout', :method => :delete)
  end
end
