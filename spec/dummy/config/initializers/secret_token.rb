# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
if Rails.version == '3.2.0'
  Dummy::Application.config.secret_token = '04cb504d4532ea6e41d7c885782aad2390c244f9708511affef23f67b0fdf17f78053da54644069112a9185141fe8be62b901ba75362d177d8e6888e704be014'
else
  Dummy::Application.config.secret_key_base = '04cb504d4532ea6e41d7c885782aad2390c244f9708511affef23f67b0fdf17f78053da54644069112a9185141fe8be62b901ba75362d177d8e6888e704be014'
end
