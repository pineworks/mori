class MoriMailer < ActionMailer::Base
  default :from => Mori.configuration.from_email

  def forgot_password(user)
    @user = user
    mail(:to => user.email, :subject => "Your password on #{Mori.configuration.app_name} has been reset")
  end

  def invite_user(user)
    @user = user
    mail(:to => user.email, :subject => "You've been invited to #{Mori.configuration.app_name}")
  end

  def confirm_email(user)
    @user = user
    mail(:to => user.email, :subject => "Please confirm your email on #{Mori.configuration.app_name}")
  end
end
