class Mori::PasswordsController < MoriController
  before_filter :authenticate!, :only => :change
  def reset
    # View for password reset
  end
  def change
    # View for change password
  end
  def send_reset
    # Send Password Reset to User
    unless Mori::User.forgot_password(params[:email])
      render :reset
    end
  end
  def update
    valid,message = current_user.change_password(params[:password],params[:new_password], params[:new_password_confirmation])
    if valid
      flash[:notice] = t('flashes.password_changed_successfully')
      redirect_to Mori.configuration.after_password_change_url
    else
      flash[:notice] = message
      render :change
    end
  end
end
