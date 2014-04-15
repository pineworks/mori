class Mori::RegistrationsController < MoriController
  def new
    if current_user
      redirect_to Mori.configuration.after_login_url
    end
    @user = Mori::User.new
  end

  def create
    @user = Mori::User.new(user_params)
    if @user.save
      warden.set_user(@user)
      redirect_to Mori.configuration.after_signup_url
    else
      flash[:notice] = @user.errors.map { |k,v| "#{k} #{v}"}.join(' and ').humanize
      render "new"
    end
  end

  def confirmation
    if params[:token]
      valid, message = Mori::User.confirm_email(params[:token])
      if valid
        flash[:notice] = message
        redirect_to Mori.configuration.dashboard_path
      else
        flash[:notice] = message
        redirect_to root_path
      end
    else
      redirect_to root_path unless params[:token]
    end
  end
  private

  def user_params
    params.require(:mori_user).permit(:username, :email, :password)
  end
end
