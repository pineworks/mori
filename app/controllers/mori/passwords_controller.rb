class Mori::PasswordsController < MoriController
  before_filter :authenticate!, :only => :change
  def forgot
    # View for sending password reset
    redirect_to Mori.configuration.dashboard_path if current_user
  end

  def change
    # View for change password
  end

  def reset
    redirect_to root_path unless params[:token]
    @user = Mori.configuration.user_model.find_by_password_reset_token(params[:token])
    redirect_to root_path unless @user
  end

  def send_reset
    # Send Password Reset to User
    render :forgot unless Mori.configuration.user_model.forgot_password(params[:email])
  end

  def update
    # Update their password
    valid, message = current_user.change_password( params[:password], params[:new_password], params[:new_password_confirmation])
    if valid
      flash[:notice] = t('flashes.password_changed_successfully')
      redirect_to Mori.configuration.after_password_change_url
    else
      flash[:notice] = message
      render :change
    end
  end

  def reset_password
    valid, message = Mori.configuration.user_model.reset_password(
      user_params[:password_reset_token],
      user_params[:password],
      user_params[:password_confirmation])
    if valid
      warden.authenticate!
      redirect_to Mori.configuration.after_login_url, notice: t('flashes.password_has_been_reset')
    else
      flash[:notice] = message
      redirect_to "/passwords/reset?token=#{user_params[:password_reset_token]}"
    end
  end
end
