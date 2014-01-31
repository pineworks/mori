require 'spec_helper'

module Mori
  describe User do

    #########################################
    # User Validation
    #########################################
    describe "is Valid: it" do
      it {should validate_presence_of(:email)}
      it {should validate_uniqueness_of(:email)}
      it {should validate_uniqueness_of(:invitation_token)}
      it {should validate_uniqueness_of(:password_reset_token)}
      it {should validate_presence_of(:password)}
      it { should allow_value('foo@example.co.uk').for(:email) }
      it { should allow_value('foo@example.com').for(:email) }
      it { should allow_value('foo+bar@example.com').for(:email) }
      it { should_not allow_value('foo@').for(:email) }
      it { should_not allow_value('foo@example..com').for(:email) }
      it { should_not allow_value('foo@.example.com').for(:email) }
      it { should_not allow_value('foo').for(:email) }
      it { should_not allow_value('example.com').for(:email) }
      it { should_not allow_value('foo;@example.com').for(:email) }

      it "should require basic information" do
        build(:mori_minimal_user).valid?.should be true
        build(:mori_invited_user).valid?.should be true
      end

    end

    #########################################
    # Post Creation/Save methods
    #########################################
    describe "after creation it" do
      it "should encrypt the password" do
        user = build(:mori_minimal_user)
        password_before = user.password
        user.save
        user.password.should eq password_before
        user.password.to_s.should_not eq password_before
      end
      it "should normalize the email" do
        user = build(:mori_minimal_user, email: 'EMAIL@exaMpLE.com') 
        before_email = user.email
        user.save
        user.email.should_not eq before_email
        user.email.should eq before_email.normalize
      end
    end

    #########################################
    # Helper methods for the User model
    #########################################
    it "#find_by_email" do
      create(:mori_minimal_user)
      User.find_by_email('email@example.com').email.should eq 'email@example.com'
    end

    #########################################
    # Inviting a User to the System
    #########################################
    describe "Inviting a User" do
      before :each do
        User.invite('aaron@aaronmiler.com')
        @user = User.find_by_email('aaron@aaronmiler.com')
      end
      it "should be invitable" do
        @user.should_not be nil
        @user.invitation_sent.should eq Date.today
      end
      describe "accepting the invitation" do
        before :each do
          User.invite('aaron@aaronmiler.com')
          @user = User.find_by_email('aaron@aaronmiler.com')
        end
        it "should set their password" do
          user = @user.accept_invitation(@user.invitation_token,"myPassword123")
          user.password.to_s.should_not eq "myPassword123"
          ::BCrypt::Password.new(user.password.to_s).should eq "myPassword123"
        end
        it "should not be able to use a stale token" do
          Timecop.freeze(Date.today + 3.weeks) do
            expect{@user.accept_invitation(@user.invitation_token,"mypassword123") }.to raise_error
          end
        end
      end
      pending "should receive an invitation email"
    end

    #########################################
    # Resetting the password
    #########################################
    describe "Resetting their password" do
      before :each do
        @user = create(:mori_minimal_user)
        User.forgot_password(@user.email)
        @user = User.find_by_email('email@example.com')
      end
      it "should be able to reset password" do
        @user.password_reset_token.should_not be nil
        @user.password_reset_sent.should eq Date.today
      end
      it "should require a valid reset token" do
        expect {@user.reset_password('token123','newPassword')}.to raise_error
        token = @user.password_reset_token 
        @user.reset_password(token, 'newPassword').password.should eq 'newPassword'
      end
      it "should not be able to use an old token" do
        token = @user.password_reset_token
        ::Timecop.freeze(Date.today + 3.weeks) do
        expect {@user.reset_password(token,'newpassword')}.to raise_error
        end
      end
      it "should receive a password reset email" do
        pending
      end
    end

    #########################################
    # Actions a User can Take
    #########################################
     
    describe "changing their password" do
      before :each do
        @user = create(:mori_minimal_user)
      end

      it "should be able to change their password" do
        newpassword = "password13"
        User.change_password(@user.email,"123456789sdf",newpassword)
        ::BCrypt::Password.new(User.find_by_email(@user.email).password).should eq newpassword
      end
      it "should raise an error if the incorrect password is provided" do
        expect{ User.change_password(@user.email,"I'mapassword","newpass")}.to raise_error
      end
    end

  end
end
