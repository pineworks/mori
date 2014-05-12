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
    if user = @config.user_model.find_by_normalized_email(params[:email])
      user.forgot_password
      render :template => 'passwords/send_reset'
    else
      render :template => 'passwords/forgot'
    end
  end

  def update
    # Update their password
    if password_change_conditions
      current_user.change_password(params[:new_password])
      flash[:notice] = t('flashes.password_changed_successfully')
      redirect_to @config.dashboard_path
    else
      flash[:notice] = I18n.t('flashes.password_change_failed')
      render :template => 'passwords/change'
    end
  end

  def reset_password
    user = @config.user_model.find_by_password_reset_token @token
    if user.nil? or @token != user.password_reset_token or user.password_reset_sent < expiration_date
      flash[:notice] = t('flashes.invalid_password_reset_token')
      redirect_to "/passwords/reset?token=#{@token}"
    else
      user.reset_password(params[:new_password])
      warden.authenticate!
      redirect_to @config.dashboard_path
    end
  end

  def password_change_conditions
    current_user.authenticate(params[:password]) && params[:new_password] == params[:new_password_confirmation]
  end
end
