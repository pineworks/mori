class Mori::InvitesController < MoriController
  before_filter :authenticate!, :only => [:new, :send]
  def show
    @user = Mori.configuration.user_model.find_by_invitation_token(params[:id])
    redirect_to root_path unless @user
  end

  def accept
    config = Mori.configuration
    valid, message = config.user_model.accept_invitation(user_params[:invitation_token], user_params[:password], user_params[:password_confirmation])
    flash[:notice] = message
    if valid
      warden.authenticate!
      redirect_to config.dashboard_path
    else
      redirect_to invite_path(user_params[:invitation_token])
    end
  end

  def send_user
    valid, message = Mori.configuration.user_model.invite(params[:email])
    flash[:notice] = message
    if valid
      redirect_to Mori.configuration.dashboard_path
    else
      render :new
    end
  end
end
