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
    user = @config.user_model.find_by_invitation_token(@token)
    if invitation_conditions(user)
      user.accept_invitation(user_params[:password])
      warden.authenticate!
      redirect_to @config.dashboard_path, :notice => I18n.t('flashes.logged_in')
    else
      flash[:notice] = I18n.t('flashes.invalid_invitation_token')
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
