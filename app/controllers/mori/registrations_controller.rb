class Mori::RegistrationsController < ActionController::Base
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
      render "new"
    end
  end
  private

  def user_params
    params.require(:mori_user).permit(:username, :email, :password)
  end
end
