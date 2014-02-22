module MoriHelper
  def logout_link(text="Log Out")
    link_to text, logout_path, :method => :delete
  end
end
