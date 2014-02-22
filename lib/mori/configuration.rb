module Mori
  class Configuration
    attr_accessor \
      :from_email,
      :application_name,
      :account_database,
      :allow_sign_up,
      :after_signup_url,
      :after_login_url,
      :after_logout_url

    def initialize
      @from_email  = "noreply@example.com"
      @application_name = "Mori"
      @allow_sign_up = true
      @after_signup_url = '/'
      @after_login_url = '/'
      @after_logout_url = '/'
    end
    def allow_sign_up?
      allow_sign_up
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
