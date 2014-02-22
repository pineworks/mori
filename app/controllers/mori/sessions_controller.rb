class Mori::SessionsController < MoriController
  def new
    redirect_to Mori.configuration.after_login_url if current_user
    @user = Mori::User.new
    flash.now.alert = warden.message if warden.message.present?
  end

  def create
    warden.authenticate!
    redirect_to Mori.configuration.after_login_url, notice: "You have logged in"
  end

  def destroy
    warden.logout
    redirect_to Mori.configuration.after_logout_url
  end
end
