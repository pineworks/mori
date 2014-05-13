module Mori
  module Controller
    extend ActiveSupport::Concern

    def authenticate!
      warden.authenticate!
    end

    def signed_in?
      current_user.preset?
    end

    def current_user
      warden.user
    end

    def warden
      env['warden']
    end

    def user_params
      user = params[:user]
      user if user.present?
    end
  end
end
