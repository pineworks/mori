require 'spec_helper'

module Mori
  describe User do
    
    let(:password){"imapassword"}
    let(:password2){"imtheotherpassword"}
    let(:email){"theemail@theexample.com"}

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
      it "should normalize the email on save" do
        user = build(:mori_minimal_user, email: "E MAIL@exa MpLE.com") 
        user.save
        user.email.should eq "email@example.com"
        user.email.should_not eq "E MAIL@exa MpLE.com"
      end
    end

    #########################################
    # Helper methods for the User model
    #########################################
    it "#find_by_normalized_email" do
      create(:mori_minimal_user)
      User.find_by_normalized_email('e maIl@eXam ple.com').email.should eq 'email@example.com'
    end

    #########################################
    # Inviting a User to the System
    #########################################
    describe "Inviting a User" do
      before :each do
        User.invite(email)
        @user = User.find_by_email(email)
      end
      it "should be invitable" do
        @user.should_not be nil
        @user.invitation_sent.should eq Date.today
      end
      describe "accepting the invitation" do
        before :each do
          User.invite(email)
          @user = User.find_by_email(email)
        end
        it "should set their password" do
          user = @user.accept_invitation(@user.invitation_token,password)
          user.password.to_s.should_not eq password
          user.password.should eq password
        end
        it "should not be able to use a stale token" do
          Timecop.freeze(Date.today + 3.weeks) do
            expect{@user.accept_invitation(@user.invitation_token,password)}.to raise_error
          end
        end
      end
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
        expect {@user.reset_password('token123',password)}.to raise_error
        token = @user.password_reset_token 
        @user.reset_password(token, password).password.should eq password
      end
      it "should not be able to use an old token" do
        token = @user.password_reset_token
        ::Timecop.freeze(Date.today + 3.weeks) do
          expect {@user.reset_password(token, password)}.to raise_error
        end
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
        User.change_password(@user.email,"123456789sdf",password2)
        ::BCrypt::Password.new(User.find_by_email(@user.email).password).should eq password2
      end
      it "should raise an error if the incorrect password is provided" do
        expect{ User.change_password(@user.email,password2,password)}.to raise_error
      end
    end

    #########################################
    # Confirming Their Email
    #########################################
    
    describe "confirming their email" do
      before :each do
        @user = create(:mori_minimal_user)
      end
      it "should require a valid token" do
        expect{User.confirm_email(@user.email, "tokentoken123")}.to raise_error
      end
      it "should require the token to be recent" do
        token = @user.confirmation_token
        ::Timecop.freeze(Date.today + 3.weeks) do
          expect {User.confirm_email(@user.email, token)}.to raise_error
        end
      end
      it "should set confirmed to true" do
        user = User.confirm_email(@user.email, @user.confirmation_token)
        user.confirmed.should eq true
      end
    end
    #########################################
    # Emails sent from the model
    #########################################
    
    describe "should recieve an email for" do
      it "getting invited" do
        Mailer.stub(:invite_user)
        Mailer.should_receive(:invite_user)
        User.invite(email)
      end
      it "resetting their password" do
        user = create(:mori_minimal_user)
        Mailer.stub(:password_reset_notification)
        Mailer.should_receive(:password_reset_notification)
        User.forgot_password(user.email)
      end
      it "confirming their email" do
        Mailer.stub(:confirm_email)
        Mailer.should_receive(:confirm_email)
        user = create(:mori_minimal_user)
      end
    end

    #########################################
    # Authentication
    #########################################

    describe "logging in" do
      before :each do
        @user = create(:mori_minimal_user, :password => password)
      end
      it "should be able to authenticate with their credentials" do
        User.authenticate(@user.email, password).should be_an_instance_of User
      end
      it "should raise an error if password is incorrect" do
        expect{User.authenticate(@user.email, password2) }.to raise_error
      end
      it "should raise an error if no user is found" do
        expect{User.authenticate(email, password) }.to raise_error
      end
    end
  end
end
