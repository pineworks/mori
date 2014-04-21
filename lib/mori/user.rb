require 'email_validator'
require 'mori/token'

module Mori
  module User
    extend ActiveSupport::Concern

    included do
      include Validations
      include Callbacks
    end

    module ClassMethods
      def find_by_normalized_email(email)
        find_by_email(email.normalize)
      end
      def confirm_email(token)
        user = find_by_confirmation_token(token)
        return false, 'Invalid Confirmation Token' if user.blank?
        return false, 'Expired Confirmation Token' if user.confirmation_sent < Date.today - 2.weeks
        user.confirmed = true
        if user.save
          return true, "Email Confirmed"
        end
      end
      def accept_invitation(token, password, password_confirmation)
        user = find_by_invitation_token(token)
        return false, I18n.t('flashes.passwords_dont_match') if password != password_confirmation
        return false, 'Expired Invitation Token' if user.invitation_sent < Date.today - 2.weeks
        user.password = password
        return true, I18n.t('flashes.logged_in') if user.save
      end
      def reset_password(token,new_password,confirmation)
        user = find_by_password_reset_token(token)
        return false, 'Passwords do not match' if new_password != confirmation
        return false, 'Invalid Password Reset Token' unless token == user.password_reset_token
        return false, 'Expired Reset Token' if user.password_reset_sent < Date.today - 2.weeks
        user.password = new_password
        user.save
      end
      def invite(email)
        user = create({:email => email, :invitation_token => Token.new, :invitation_sent => Date.today})
        if user.save
          Mori::Mailer.invite_user(user)
          return true, user
        else
          return false, I18n.t('flashes.could_not_invite_user')
        end
      end
      def forgot_password(email)
        user = find_by_normalized_email(email)
        return false if user.blank?
        user.password_reset_token = Token.new
        user.password_reset_sent = Date.today
        Mori::Mailer.password_reset_notification(user)
        user.save
      end
    end

    module Callbacks
      extend ActiveSupport::Concern

      included do
        before_save :encrypt_password, :if => Proc.new { |user| user.password_changed? }
        before_validation :normalize_email, :if => Proc.new{ |user| user.email_changed? }
        before_create :send_email_confirmation, :if => Proc.new { |user| user.password.present? }
      end
    end

    module Validations
      extend ActiveSupport::Concern
      included do
        validates :email, email: { strict_mode: true }, presence: true, uniqueness: true
        validates :password, presence: true, unless: :invitation_token?
        validates :password_reset_token, uniqueness: true, if: :password_reset_token?
        validates :invitation_token, uniqueness: true, if: :invitation_token?
      end
    end

    def change_password(password, new_password, confirm)
      return false, I18n.t('flashes.password_change_failed') if ::BCrypt::Password.new(self.password) != password
      return false, I18n.t('flashes.passwords_did_not_match') if new_password != confirm
      self.password = new_password
      self.save
    end
    def authenticate(password)
      return false if ::BCrypt::Password.new(self.password) != password
      true
    end

    private

    def send_email_confirmation
      self.confirmation_token = SecureRandom.hex(25)
      self.confirmation_sent = Date.today
      Mori::Mailer.confirm_email(self)
    end
    def encrypt_password
      self.password = self.password.encrypt
    end
    def normalize_email
      self.email = self.email.normalize
    end
  end
end

