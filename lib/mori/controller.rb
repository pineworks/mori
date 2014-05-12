module Mori
  module Controller
    extend ActiveSupport::Concern

    def expiration_date
      Date.today - Mori.configuration.token_expiration.days
    end

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
      params[:user] if params[:user].present?
    end

    def invitation_conditions(user)
      user.invitation_sent > expiration_date
    end
  end
end
