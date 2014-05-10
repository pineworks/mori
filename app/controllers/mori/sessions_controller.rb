# Mori::SessionsController is responsible for creating and destroying sessions
class Mori::SessionsController < Mori::BaseController
  def new
    if current_user
      redirect_to @config.dashboard_path
    else
      @user = @config.user_model.new
      flash.now.alert = warden.message if warden.message.present?
      render :template => 'sessions/new'
    end
  end

  def create
    warden.authenticate!
    redirect_to @config.dashboard_path, :notice => 'You have logged in'
  end

  def destroy
    warden.logout
    redirect_to @config.after_logout_path
  end
end
