module Mori
  class Configuration
    attr_accessor \
      :from_email,
      :application_name,
      :account_database

    def initialize
      @from_email  = "noreply@example.com"
      @application_name = "Mori"
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
