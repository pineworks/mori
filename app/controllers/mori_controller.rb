class MoriController < ActionController::Base
  def authenticate!
    warden.authenticate!
  end
  def signed_in?
    !current_user.nil?
  end
  def current_user
    warden.user
  end
  def warden
    env['warden']
  end
end
