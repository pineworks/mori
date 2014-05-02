module Mori
  module Controller
    extend ActiveSupport::Concern

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

    def user_params
      params[:user] if params[:user].present?
    end
  end
end
