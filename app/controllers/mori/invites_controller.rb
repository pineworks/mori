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
end
