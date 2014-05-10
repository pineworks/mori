# Mori::InvitesController handles the sending and acceping of invitations
class Mori::InvitesController < Mori::BaseController
  before_filter :authenticate!, :only => [:new, :send]
  def show
    @user = @config.user_model.find_by_invitation_token(params[:id])
    if @user
      render :template => 'invites/show'
    else
      redirect_to root_path
    end
  end

  def new
    render :template => 'invites/new'
  end

  def accept
    valid, message = @config.user_model.accept_invitation(@token, user_params[:password], user_params[:password_confirmation])
    flash[:notice] = message
    if valid
      warden.authenticate!
      redirect_to @config.dashboard_path
    else
      redirect_to invite_path(@token)
    end
  end

  def send_user
    valid, message = @config.user_model.invite(params[:email])
    flash[:notice] = message
    if valid
      redirect_to @config.dashboard_path
    else
      render :template => 'invites/new'
    end
  end
end
