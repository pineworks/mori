module Mori::Controllers::Helpers
      extend ActiveSupport::Concern

      included do
        helper_method :warden, :signed_in?, :authenticate!, :current_user, :user_params
      end

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
        if params[:mori_user].present?
          params[:mori_user]
        end
      end
end
