require 'bcrypt'

class String
  include BCrypt

  def encrypt
    Password.create(self, :cost => cost)
  end
  def normalize
    self.remove_whitespace.downcase
  end
  def remove_whitespace
   self.gsub(/\s+/, '')
  end

  private
  def cost
    ::BCrypt::Engine::DEFAULT_COST
  end
end
