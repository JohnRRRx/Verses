Rails.application.config.sorcery.submodules = [:external, :reset_password]
Rails.application.config.sorcery.configure do |config|
  config.external_providers = [:google]
  config.google.key = ENV['GOOGLE_CLIENT_ID']
  config.google.secret = ENV['GOOGLE_CLIENT_SECRET']
  config.google.callback_url = "https://slimy-ilsa-nonamejusttest-74953f89.koyeb.app/oauth/callback?provider=google"
  config.google.user_info_mapping = { email: "email", name: "name" }

  config.user_config do |user|
    user.reset_password_mailer = UserMailer
  user.stretches = 1 if Rails.env.test?
  user.authentications_class = Authentication
  end
  config.user_class = 'User'
end
