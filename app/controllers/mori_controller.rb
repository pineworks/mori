class MoriController < ApplicationController
  def current_user
    warden.user
  end
  def warden
    env['warden']
  end
end
