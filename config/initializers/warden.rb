Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Mori::SessionsController.action(:new)
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  Mori.configuration.user_model.find(id)
end

Warden::Strategies.add(:password) do
  def valid?
    params['user'].present? and params['user']['email'] and params['user']['password']
  end

  def authenticate!
    user = User.find_by_email(params['user']['email'])
    if user and user.authenticate(params['user']['password'])
      success! user
    else
      fail! "Invalid login credentials"
    end
  end
end
