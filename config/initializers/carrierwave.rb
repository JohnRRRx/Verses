CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['R2_ACCESS_KEY'],
      aws_secret_access_key: ENV['R2_SECRET_KEY'],
      endpoint: "https://#{ENV['CLOUDFLARE_ACCOUNT_ID']}.r2.cloudflarestorage.com",
      region: 'auto'
    }
    config.fog_directory = ENV['R2_BUCKET']
    config.fog_public = false  # 非公開設定
  else
    config.storage = :file
  end
end