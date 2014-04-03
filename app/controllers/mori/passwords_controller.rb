class Mori::PasswordsController < MoriController
  before_filter :authenticate!, :only => :change
  def forgot
    # View for sending password reset
  end
  def change
    # View for change password
  end
  def reset
    @user = Mori::User.find_by_password_reset_token(params[:token])
    redirect_to root_path unless @user
  end
  def send_reset
    # Send Password Reset to User
    unless Mori::User.forgot_password(params[:email])
      render :forgot
    end
  end
  def update
    # Update their password
    valid,message = current_user.change_password(params[:password],params[:new_password], params[:new_password_confirmation])
    if valid
      flash[:notice] = t('flashes.password_changed_successfully')
      redirect_to Mori.configuration.after_password_change_url
    else
      flash[:notice] = message
      render :change
    end
  end
  def reset_password
    render :reset if params[:mori_user][:password] != params[:mori_user][:password_confirmation]
    valid, message = Mori::User.reset_password(params[:mori_user][:password_reset_token],params[:mori_user][:password])
    if valid
      warden.authenticate!
      redirect_to Mori.configuration.after_login_url, notice: "You have logged in"
    else
      flash[:notice] = message
      render :reset
    end
  end
end
