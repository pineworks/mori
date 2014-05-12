require 'email_validator'
require 'mori/token'
require 'mori/password'

module Mori
  module User
    extend ActiveSupport::Concern

    included do
      include Password

      include Validations
      include Callbacks
    end

    module ClassMethods

      def find_by_normalized_email(email)
        find_by_email(normalize_email(email))
      end

      def normalize_email(string)
        string.gsub(/\s+/, '').downcase
      end

      def invite(email)
        user = create(
          :email => email,
          :invitation_token => Token.new,
          :invitation_sent => Date.today)
        if user.save
          MoriMailer.invite_user(user)
          return true, "An invite has been sent to #{email}"
        else
          return false, I18n.t('flashes.could_not_invite_user')
        end
      end

    end

    module Callbacks
      extend ActiveSupport::Concern

      included do
        before_save :encrypt_password, :if => proc { |user| user.password_changed? }
        before_validation :normalize_email, :if => proc { |user| user.email_changed? }
        before_create :send_email_confirmation, :if => proc { |user| user.password.present? }
      end
    end

    module Validations
      extend ActiveSupport::Concern
      included do
        validates :email, :email => { :strict_mode => true }, :presence => true, :uniqueness => true
        validates :password, :presence => true, :unless => :invitation_token?
        validates :password_reset_token, :uniqueness => true, :if => :password_reset_token?
        validates :invitation_token, :uniqueness => true, :if => :invitation_token?
      end
    end

    def accept_invitation(password)
      self.password = password
      self.confirmed = true
      self.save
    end

    def change_password(new_password)
      self.password = new_password
      save
    end

    def forgot_password
      self.password_reset_token = Token.new
      self.password_reset_sent = Date.today
      MoriMailer.forgot_password(self)
      save
    end

    def confirm_email
      self.confirmed = true
      self.save
    end

    def reset_password(new_password)
      self.password = new_password
      self.save
    end

    def authenticate(password)
      ::BCrypt::Password.new(self.password) == password
    end

    private

    def normalize_email
      self.email = self.class.normalize_email(email)
    end

    def send_email_confirmation
      self.confirmation_token = SecureRandom.hex(25)
      self.confirmation_sent = Date.today
      MoriMailer.confirm_email(self)
    end

    def encrypt_password
      self.password = encrypt(password)
    end


  end
end
