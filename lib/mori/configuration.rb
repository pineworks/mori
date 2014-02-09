module Mori
  class Configuration
    attr_accessor \
      :from_email,
      :application_name,
      :account_database,
      :allow_sign_up

    def initialize
      @from_email  = "noreply@example.com"
      @application_name = "Mori"
      @allow_sign_up = true
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
