class Mori::PasswordsController < MoriController
  def reset
    # View for password reset
  end
  def change
    # View for change password
  end
  def send_reset
    # Send Password Reset to User
    #Mori::User.forgot_password(params[:email])
  end
  def update
    if params[:mori_user][:password_reset_token]
      # forgot password
    else
      # change
    end
  end
end
