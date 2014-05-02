class Mori::SessionsController < Mori::BaseController
  def new
    if current_user
      redirect_to Mori.configuration.dashboard_path
    else
      @user = Mori.configuration.user_model.new
      flash.now.alert = warden.message if warden.message.present?
      render :template => 'sessions/new'
    end
  end

  def create
    warden.authenticate!
    redirect_to Mori.configuration.dashboard_path, :notice => 'You have logged in'
  end

  def destroy
    warden.logout
    redirect_to Mori.configuration.after_logout_path
  end
end
