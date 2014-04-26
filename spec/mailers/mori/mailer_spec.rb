require 'spec_helper'

module Mori
  describe Mailer do
    before :each do
      @user = create(:mori_minimal_user, :invitation_token => Token.new, :password_reset_token => Token.new)
      @host = ::ActionMailer::Base.default_url_options[:host]
    end
    it "is from configuration email" do
      email = Mailer.forgot_password(@user)
      Mori.configuration.from_email.should eq email.from[0]
    end
    it "should contain an invite url in invite email" do
      email = Mailer.invite_user(@user)
      regexp = %r{http://#{@host}/invites/#{@user.invitation_token}}
      email.body.to_s.should =~ regexp
    end
    it "should contain password reset URL in forgot password email" do
      email = Mailer.forgot_password(@user)
      regexp = %r{http://#{@host}/passwords/forgot\?token=#{@user.password_reset_token}}
      email.body.to_s.should =~ regexp
    end
    it "should contain confirmation URL in confirmation email" do
      email = Mailer.confirm_email(@user)
      regexp = %r{http://#{@host}/registrations/confirmation\?token=#{@user.confirmation_token}}
      email.body.to_s.should =~ regexp
    end
  end
end
