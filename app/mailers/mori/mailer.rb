module Mori
  class Mailer < ActionMailer::Base
    default :from => Mori.configuration.from_email

    def password_reset_notification(user)
      @user = user
      mail(:to => user.email, :subject => "Your password on #{Mori.configuration.application_name} has been reset")
    end

    def invite_user(user)
      @user = user
      mail(:to => user.email, :subject => "You've been invited to #{Mori.configuration.application_name}")
    end

    def confirm_email(user)
      @user = user
    end
  end
end
