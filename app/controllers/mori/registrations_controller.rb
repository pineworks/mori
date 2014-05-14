# Mori::RegistrationsController is responsible for signing up new users
class Mori::RegistrationsController < Mori::BaseController
  def new
    if current_user
      redirect_to @config.dashboard_path
    else
      @user = @config.user_model.new
      render :template => 'registrations/new'
    end
  end

  def create
    @user = user_from_params
    if @user.save
      warden.authenticate!
      redirect_to @config.after_sign_up_path
    else
      flash[:notice] = @user.errors.map { |key, val| "#{key} #{val}" }.join(' and ').humanize
      render :template => 'registrations/new'
    end
  end

  def confirmation
    user = @config.user_model.find_by_confirmation_token(@token)
    if confirmation_conditions(user)
      user.confirm_email
      flash[:notice] = I18n.t('flashes.email_confirmed')
      redirect_to @config.dashboard_path
    else
      flash[:notice] = I18n.t('flashes.invalid_confirmation_token')
      redirect_to root_path
    end
  end

  private

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)

    @config.user_model.new().tap do |user|
      user.email = email
      user.password = password
    end
  end

  def user_params
    params[:user] || Hash.new
  end

  def confirmation_conditions(user)
    begin
      user.confirmation_sent > Mori::Token.expiration_date
    rescue
      return false
    end
  end
end
