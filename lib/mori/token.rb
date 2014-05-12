module Mori
  class Token
    def self.new
      SecureRandom.hex(10).encode('UTF-8')
    end
  end
end
