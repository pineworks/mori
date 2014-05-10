# Mori::PasswordsController is responsible for changing and resetting passwords
class Mori::PasswordsController < Mori::BaseController
  before_filter :authenticate!, :only => :change
  def forgot
    # View for sending password reset
    if current_user
      redirect_to @config.dashboard_path
    else
      render :template => 'passwords/forgot'
    end
  end

  def change
    # View for change password
    render :template => 'passwords/change'
  end

  def reset
    @user = @config.user_model.find_by_password_reset_token(@token) unless @token.blank?
    if @user
      render :template => 'passwords/reset'
    else
      redirect_to root_path
    end
  end

  def send_reset
    # Send Password Reset to User
    if !@config.user_model.forgot_password(params[:email])
      render :template => 'passwords/forgot'
    else
      render :template => 'passwords/send_reset'
    end
  end

  def update
    # Update their password
    valid, message = current_user.change_password(params[:password], params[:new_password], params[:new_password_confirmation])
    if valid
      flash[:notice] = t('flashes.password_changed_successfully')
      redirect_to @config.dashboard_path
    else
      flash[:notice] = message
      render :template => 'passwords/change'
    end
  end

  def reset_password
    valid, message = @config.user_model.reset_password(@token, user_params[:password], user_params[:password_confirmation])
    flash[:notice] = message
    if valid
      warden.authenticate!
      redirect_to @config.dashboard_path
    else
      redirect_to "/passwords/reset?token=#{@token}"
    end
  end
end
