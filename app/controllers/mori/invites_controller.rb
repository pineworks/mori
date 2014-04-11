class Mori::InvitesController < MoriController
  before_filter :authenticate!, :only => [:new, :send]
  def show
    @user = Mori::User.find_by_invitation_token(params[:id])
    unless @user
      redirect_to root_url
    end
  end
  def accept
    valid, message = Mori::User.accept_invitation(user_params[:invitation_token],user_params[:password],user_params[:password_confirmation])
    puts message
    if valid
      warden.authenticate!
      flash[:notice] = message
      redirect_to Mori.configuration.dashboard_path
    else
      flash[:notice] = message
      redirect_to invite_path(user_params[:invitation_token])
    end
  end
  def send_user
    valid, message = Mori::User.invite(params[:email])
    if valid
      flash[:notice] = "An invite has been sent to #{params[:email]}"
      redirect_to Mori.configuration.after_invite_url
    else
      flash[:notice] = message
      render :new
    end
  end
end
