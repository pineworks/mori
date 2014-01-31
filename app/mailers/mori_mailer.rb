class MoriMailer < ActionMailer::Base
  default from: Mori.configuration.from_email

  def confirm_email(user)
    @confirmation = user.confirmation_token
    mail(to: user.email)
  end
  def invitation_email(user)
    @invitation_token = user.invitation_token
    mail(to:user.mail)
  end
end
