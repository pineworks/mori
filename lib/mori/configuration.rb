module Mori
  class Configuration
    attr_accessor \
      :from_email,
      :application_name,
      :account_database,
      :allow_sign_up,
      :after_signup_url,
      :after_login_url,
      :after_logout_url,
      :after_password_change_url,
      :after_invite_url,
      :dashboard_path,
      :user_model

    def initialize
      @from_email  = "noreply@example.com"
      @application_name = "Mori"
      @allow_sign_up = true
      @after_signup_url = '/'
      @after_login_url = '/'
      @after_logout_url = '/'
      @after_password_change_url = '/'
      @after_invite_url = '/'
      @dashboard_path = '/'
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
