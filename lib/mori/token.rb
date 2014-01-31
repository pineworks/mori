module Mori
  module Token
    extend ActiveSupport::Concern

    included do
      generate_token 
    end

    module ClassMethods

      def generate_token
        SecureRandom.hex(25)
      end
    end
  end
end
