# Mori Configuration is for setting application wide settings
module Mori
  class Configuration
    attr_accessor \
      :from_email,
      :app_name,
      :allow_sign_up,
      :after_sign_up_path,
      :after_logout_path,
      :dashboard_path,
      :user_model,
      :token_expiration

    def initialize
      @from_email  = 'noreply@example.com'
      @app_name = Rails.application.class.parent_name.humanize
      @allow_sign_up = true
      @after_sign_up_path = '/'
      @after_logout_path = '/'
      @dashboard_path = '/'
      @token_expiration = 14
    end

    def allow_sign_up?
      allow_sign_up
    end

    def user_model
      @user_model || ::User
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
