CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.development?
    config.storage :file
    config.asset_host = 'http://localhost:3000'
    config.root = "#{Rails.root}/public"
  else
    config.fog_provider = 'fog/aws'
    config.fog_use_ssl_for_aws = true
    config.fog_directory  = '/'
    config.fog_public     = false
    config.fog_attributes = { 'Cache-Control': 'max-age=315576000' }
    config.asset_host = 'https://nsb-storage.s3.amazonaws.com'

    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV['S3_KEY'],
      aws_secret_access_key:  ENV['S3_SECRET'],
      region:                 ENV['S3_REGION']
    }
    config.storage = :fog

  end
end
