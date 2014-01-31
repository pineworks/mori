require 'email_validator'

module Mori
  class User < ActiveRecord::Base
    include Mori::Token

    def self.invite(email)
      user = User.create({:email => email, :invitation_token => generate_token, :invitation_sent => Date.today})
    end
    def self.forgot_password(email)
      user = User.find_by_email(email)
      user.password_reset_token = generate_token
      user.password_reset_sent = Date.today
      user.save
    end


    validates :email, email: { strict_mode: true }, presence: true, uniqueness: true
    validates :password, presence: true, unless: :invitation_token?
    validates :password_reset_token, uniqueness: true
    validates :invitation_token, uniqueness: true

    before_save :normalize_email, :if => Proc.new { |user| user.email_changed? }
    before_save :encrypt_password, :if => Proc.new { |user| user.password_changed? }


    def authenticate(email,password)
      User.find_by_email(email)
    end
    def reset_password(token,new_password)
      raise 'Invalid Password Reset Token' unless token == self.password_reset_token
      raise 'Expired Reset Token' if self.password_reset_sent < Date.today - 2.weeks
      self.password = new_password
      self.save
      self
    end
    def self.change_password(email, password, new_password)
      user = User.find_by_email(email.normalize)
      raise "Passwords do not match" if ::BCrypt::Password.new(user.password) != password
      user.password = new_password
      user.save
      user
    end
    def accept_invitation(token,password)
      user = User.find_by_invitation_token(token)
      raise 'Expired Invitation Token' if user.invitation_sent < Date.today - 2.weeks
      user.password = password.encrypt
      user.save
      user
    end
    def encrypt_password
      self.password = self.password.encrypt
    end
    def normalize_email
      self.email = self.email.normalize
    end
  end
end
