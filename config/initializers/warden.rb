Rails.application.config.middleware.use do |manager|
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
    user_params.present? and user_params['email'] and user_params['password']
  end

  def authenticate!
    user = User.find_by_email(user_params['email'])
    if user and user.authenticate(user_params['password'])
      success! user
    else
      fail! "Invalid login credentials"
    end
  end
  def user_params
    params['user']
  end
end
