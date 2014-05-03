Mori.configure do |config|

  # Mori Configuration Options

  config.from_email = 'reply@example.com'

  ##  Other Configuration Options

  # Configure the Application name, used in e-mails
  # Default: Rails.application.class.parent_name.humanize
  # config.app_name = "My Application Name"

  # Allow users to sign up? Setting to false prevents the sign up action
  # Default: True
  # config.allow_sign_up = true/false

  # Whre users are sent after login, password change, and other actions
  # Default: Root Path
  # config.dashboard_path = '/dashboard'

  # Where users are sent after signup
  # Default: Root Path
  # config.after_sign_up_path = '/welcome'

  # Where users are sent after logging out
  # Default: Root Path
  # config.after_logout_path = '/destination_path'

  # Configure How long till Reset/Confirmation/Invitation Tokens Expire (in Days)
  # Default: 14 days
  # config.token_expiration = 14
end
