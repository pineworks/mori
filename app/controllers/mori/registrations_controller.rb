class Mori::RegistrationsController < Mori::BaseController
  def new
    if current_user
      redirect_to Mori.configuration.dashboard_path
    else
      @user = Mori.configuration.user_model.new
      render :template => 'registrations/new'
    end
  end

  def create
    @user = user_from_params
    if @user.save
      warden.set_user(@user)
      redirect_to Mori.configuration.after_sign_up_path
    else
      flash[:notice] = @user.errors.map { |k, v| "#{k} #{v}" }.join(' and ').humanize
      render :template => 'registrations/new'
    end
  end

  def confirmation
    valid, message = Mori.configuration.user_model.confirm_email(params[:token])
    if valid
      flash[:notice] = message
      redirect_to Mori.configuration.dashboard_path
    else
      flash[:notice] = message
      redirect_to root_path
    end
  end

  private

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)

    Mori.configuration.user_model.new().tap do |user|
      user.email = email
      user.password = password
    end
  end

  def user_params
    params[:user] || Hash.new
  end
end
