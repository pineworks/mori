class Mori::InvitesController < MoriController
  def show
    @user = Mori::User.find_by_invitation_token(params[:id])
    unless @user
      redirect_to root_url
    end
  end
  def accept
  end
end
