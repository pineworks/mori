class Mori::InvitesController < MoriController
  before_filter :authenticate!, :only => [:new, :send]
  def show
    @user = Mori::User.find_by_invitation_token(params[:id])
    unless @user
      redirect_to root_url
    end
  end
  def new
  end
  def accept
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