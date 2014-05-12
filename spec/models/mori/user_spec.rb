require 'spec_helper'

describe User do

  let(:password) { 'imapassword' }
  let(:password2) { 'imtheotherpassword' }
  let(:email) { 'theemail@theexample.com' }

  #########################################
  # User Validation
  #########################################

  describe 'is Valid: it' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should allow_value('foo@example.co.uk').for(:email) }
    it { should allow_value('foo@example.com').for(:email) }
    it { should allow_value('foo+bar@example.com').for(:email) }
    it { should_not allow_value('foo@').for(:email) }
    it { should_not allow_value('foo@example..com').for(:email) }
    it { should_not allow_value('foo@.example.com').for(:email) }
    it { should_not allow_value('foo').for(:email) }
    it { should_not allow_value('example.com').for(:email) }
    it { should_not allow_value('foo;@example.com').for(:email) }

    it 'should require basic information' do
      build(:mori_minimal_user).valid?.should be true
      build(:mori_invited_user).valid?.should be true
    end
  end

  #########################################
  # Post Creation/Save methods
  #########################################
  describe 'after creation it' do
    it 'should encrypt the password' do
      user = build(:mori_minimal_user)
      password_before = user.password
      user.save
      user.password.should eq password_before
      user.password.to_s.should_not eq password_before
    end
    it 'should normalize the email on save' do
      user = build(:mori_minimal_user, :email => 'E MAIL@exa MpLE.com')
      user.save
      user.email.should eq 'email@example.com'
      user.email.should_not eq 'E MAIL@exa MpLE.com'
    end
  end

  #########################################
  # Helper methods for the User model
  #########################################
  it '#find_by_normalized_email' do
    create(:mori_minimal_user)
    user = User.find_by_normalized_email('e maIl@eXam ple.com')
    user.email.should eq 'email@example.com'
  end

  #########################################
  # Inviting a User to the System
  #########################################
  describe 'Inviting a User' do
    before :each do
      User.invite(email)
      @user = User.find_by_email(email)
    end
    it 'should be invitable' do
      @user.should_not be nil
      @user.invitation_sent.should eq Date.today
    end
    it 'should not be able to invite a user that exists' do
      valid, message = User.invite(email)
      valid.should be false
      message.should eq I18n.t('flashes.could_not_invite_user')
    end
    describe 'accepting the invitation' do
      before :each do
        User.invite(email)
        @user = User.find_by_email(email)
      end
      it 'should set their password' do
        @user.accept_invitation(password)
        @user.reload.password.should_not eq password
      end
    end
  end

  #########################################
  # Resetting the password
  #########################################
  describe 'Resetting their password' do
    before(:each) do
      @user = create(:mori_minimal_user)
      @user.forgot_password
      @user = User.find_by_email(@user.email)
    end
    it 'should be able to reset password' do
      @user.password_reset_token.should_not be nil
      @user.password_reset_sent.should eq Date.today
    end
    it 'should change their password' do
      @user.reset_password("password123")
      ::BCrypt::Password.new(@user.reload.password).should eq "password123"
    end
  end

  #########################################
  # Actions a User can Take
  #########################################

  describe 'changing their password' do
    before :each do
      @user = create(:mori_minimal_user)
    end
    it 'should be able to change their password' do
      @user.change_password(password2)
      ::BCrypt::Password.new(@user.reload.password).should eq password2
    end
  end

  #########################################
  # Confirming Their Email
  #########################################

  describe 'confirming their email' do
    before :each do
      @user = create(:mori_minimal_user)
    end
    it 'should set confirmed to true' do
      @user.confirm_email
      @user.reload.confirmed.should eq true
    end
  end

  #########################################
  # Emails sent from the model
  #########################################
  describe 'should recieve an email for' do
    it 'getting invited' do
      MoriMailer.should_receive(:invite_user).and_call_original
      User.invite(email)
    end
    it 'resetting their password' do
      user = create(:mori_minimal_user)
      MoriMailer.should_receive(:forgot_password).and_call_original
      user.forgot_password
    end
    it 'confirming their email' do
      MoriMailer.should_receive(:confirm_email).and_call_original
      create(:mori_minimal_user)
    end
  end

  #########################################
  # Authentication
  #########################################

  describe 'logging in' do
    before :each do
      @user = create(:mori_minimal_user, :password => password)
    end
    it 'should be able to authenticate with their credentials' do
      @user.authenticate(password).should eq true
    end
    it 'should raise an error if password is incorrect' do
      @user.authenticate(password2).should eq false
    end
  end
end
