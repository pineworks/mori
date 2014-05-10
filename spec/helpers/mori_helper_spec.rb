require 'spec_helper'
describe MoriHelper do
  it 'should return the logout link' do
    mori_logout_link.should eq link_to('Log Out', '/logout', :method => :delete)
  end
end
