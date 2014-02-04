require 'email_validator'

module Mori
  include BCrypt
  class User < ActiveRecord::Base
    include Mori::Token

    validates :email, email: { strict_mode: true }, presence: true, uniqueness: true
    validates :password, presence: true, unless: :invitation_token?
    validates :password_reset_token, uniqueness: true
    validates :invitation_token, uniqueness: true

    before_save :normalize_email, :if => Proc.new { |user| user.email_changed? }
    before_save :encrypt_password, :if => Proc.new { |user| user.password_changed? }
    before_create :send_email_confirmation, :if => Proc.new { |user| user.password.present? }

    # Methods called by ActiveRecord

    def encrypt_password
      self.password = self.password.encrypt
    end
    def normalize_email
      self.email = self.email.normalize
    end
    def send_email_confirmation
      self.confirmation_token = SecureRandom.hex(25)
      self.confirmation_sent = Date.today
      Mailer.confirm_email(self)
    end

    def accept_invitation(token,new_password)
      user = User.find_by_invitation_token(token)
      raise 'Expired Invitation Token' if user.invitation_sent < Date.today - 2.weeks
      user.password = new_password
      user.save
      user
    end
    def reset_password(token,new_password)
      raise 'Invalid Password Reset Token' unless token == self.password_reset_token
      raise 'Expired Reset Token' if self.password_reset_sent < Date.today - 2.weeks
      self.password = new_password
      self.save
      self
    end

    def self.invite(email)
      user = User.create({:email => email, :invitation_token => generate_token, :invitation_sent => Date.today})
      Mailer.invite_user(user)
    end
    def self.forgot_password(email)
      user = User.find_by_email(email)
      user.password_reset_token = generate_token
      user.password_reset_sent = Date.today
      Mailer.password_reset_notification(user)
      user.save
    end
    def self.change_password(email, password, new_password)
      user = User.find_by_normalized_email(email.normalize)
      raise "Passwords do not match" if ::BCrypt::Password.new(user.password) != password
      user.password = new_password
      user.save
      user
    end
    def self.confirm_email(email, token)
      user = User.find_by_confirmation_token(token)
      raise 'Invalid Confirmation Token' if user.blank?
      raise 'Expired Confirmation Token' if user.confirmation_sent < Date.today - 2.weeks
      user.confirmed = true
      user.save
      user
    end
    def self.authenticate(email, password)
      user = User.find_by_normalized_email(email)
      raise 'Invalid Login' if user.blank? or ::BCrypt::Password.new(user.password) != password
      user
    end
    protected
    def self.find_by_normalized_email(email)
      User.find_by_email(email.normalize)
    end
  end
end
