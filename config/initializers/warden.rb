Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Mori::SessionsController.action(:new)
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  Mori::User.find(id)
end

Warden::Strategies.add(:password) do
  def valid?
    params['mori_user'].present? and params['mori_user']['email'] and params['mori_user']['password']
  end

  def authenticate!
    user = Mori::User.find_by_email(params['mori_user']['email'])
    if user and user.authenticate(params['mori_user']['password'])
      success! user
    else
      fail "Invalid login credentials"
    end
  end
end
