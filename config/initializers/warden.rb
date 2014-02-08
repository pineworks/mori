Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :authentication
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

Warden::Strategies.add(:authentication) do
  def valid?
    params['email'] and params['pasword']
  end

  def authenticate!
    user = User.find_by_email(params['email'])
    if user and user.authenticate(params['password'])
      success! user
    else
      fail "Invalid login credentials"
    end
  end
end
