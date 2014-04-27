class Mori::RegistrationsController < MoriController
  def new
    redirect_to Mori.configuration.dashboard_path if current_user
    @user = Mori.configuration.user_model.new
  end

  def create
    @user = Mori.configuration.user_model.new(user_params)
    if @user.save
      warden.set_user(@user)
      redirect_to Mori.configuration.after_sign_up_path
    else
      flash[:notice] = @user.errors.map { |k, v| "#{k} #{v}" }.join(' and ').humanize
      render 'new'
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

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
