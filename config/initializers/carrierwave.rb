CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('R2_ACCESS_KEY', nil),
      aws_secret_access_key: ENV.fetch('R2_SECRET_KEY', nil),
      endpoint: "https://#{ENV.fetch('CLOUDFLARE_ACCOUNT_ID', nil)}.r2.cloudflarestorage.com",
      region: 'auto'
    }
    config.fog_directory = ENV.fetch('R2_BUCKET', nil)
    config.fog_public = false # 非公開設定
  else
    config.storage = :file
  end
end
