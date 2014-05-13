module Mori
  # Mori::Token is used to generate Password Reset, Invitaiton and Confirmation tokens
  class Token
    def self.new
      SecureRandom.hex(10).encode('UTF-8')
    end
    def self.expiration_date
      Date.today - Mori.configuration.token_expiration.days
    end
  end
end
