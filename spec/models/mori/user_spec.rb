require 'spec_helper'

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
    it "should not be able to invite a user that exists" do
      valid, message = User.invite(email)
      valid.should be false
      message.should eq I18n.t('flashes.could_not_invite_user')
    end
    describe "accepting the invitation" do
      before :each do
        User.invite(email)
        @user = User.find_by_email(email)
      end
      it "should set their password" do
        User.accept_invitation(@user.invitation_token,password,password)
        @user.reload.password.should_not eq password
      end
      it "should not be able to use a stale token" do
        Timecop.freeze(Date.today + 3.weeks) do
          valid, message = User.accept_invitation(@user.invitation_token,password,password)
          valid.should eq false
          message.should eq 'Expired Invitation Token'
        end
      end
    end
  end

  #########################################
  # Resetting the password
  #########################################
  describe "Resetting their password" do
    before(:each) do
      @user = create(:mori_minimal_user)
      User.forgot_password(@user.email)
      @user = User.find_by_email('email@example.com')
    end
    it "should be able to reset password" do
      @user.password_reset_token.should_not be nil
      @user.password_reset_sent.should eq Date.today
    end
    it "should require a valid reset token" do
      expect {User.reset_password('token123',password)}.to raise_error
      token = @user.password_reset_token
      User.reset_password(token, password, password)
      ::BCrypt::Password.new(User.find_by_email(@user.email).password).should eq password
    end
    it "should not be able to use an old token" do
      token = @user.password_reset_token
      ::Timecop.freeze(Date.today + 3.weeks) do
        valid, message = User.reset_password(token, password, password)
        valid.should eq false
        message.should eq 'Expired Reset Token'
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
      @user.change_password("123456789sdf",password2,password2)
      ::BCrypt::Password.new(User.find_by_email(@user.email).password).should eq password2
    end
    it "should return false if both new passwords don't match" do
      valid,message = @user.change_password("123456789sdf",password2,"potato")
      valid.should eq false
      message.should eq I18n.t('flashes.passwords_did_not_match')
    end
    it "should raise an error if the incorrect password is provided" do
      valid, message = @user.change_password(password2,password,password)
      valid.should eq false
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
      valid,message = User.confirm_email("tokentoken123")
      valid.should eq false
      message.should eq 'Invalid Confirmation Token'
    end
    it "should require the token to be recent" do
      token = @user.confirmation_token
      ::Timecop.freeze(Date.today + 3.weeks) do
        valid,message = User.confirm_email(token)
        valid.should eq false
        message.should eq "Expired Confirmation Token"
      end
    end
    it "should set confirmed to true" do
      valid, message = User.confirm_email(@user.confirmation_token)
      valid.should eq true
      message.should eq "Email Confirmed"
    end
  end

  #########################################
  # Emails sent from the model
  #########################################
  describe "should recieve an email for" do
    it "getting invited" do
      Mori::Mailer.should_receive(:invite_user).and_call_original
      User.invite(email)
    end
    it "resetting their password" do
      user = create(:mori_minimal_user)
      Mori::Mailer.should_receive(:password_reset_notification).and_call_original
      User.forgot_password(user.email)
    end
    it "confirming their email" do
      Mori::Mailer.should_receive(:confirm_email).and_call_original
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
      @user.authenticate(password).should eq true
    end
    it "should raise an error if password is incorrect" do
      @user.authenticate(password2).should eq false
    end
  end
end
