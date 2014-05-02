require 'bcrypt'

module Mori
  module Password
    include BCrypt

    def encrypt(string)
      ::BCrypt::Password.create(string, :cost => cost)
    end

    def compare_encrypted(string)
      ::BCrypt::Password.new(string)
    end

    private

    def cost
      ::BCrypt::Engine::DEFAULT_COST
    end
  end
end
