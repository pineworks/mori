class Mori::SessionsController < MoriController
  def new
    redirect_to Mori.configuration.dashboard_path if current_user
    @user = Mori.configuration.user_model.new
    flash.now.alert = warden.message if warden.message.present?
  end

  def create
    warden.authenticate!
    redirect_to Mori.configuration.dashboard_path, :notice => 'You have logged in'
  end

  def destroy
    warden.logout
    redirect_to Mori.configuration.after_logout_url
  end
end
