Apipie.configure do |config|
  config.app_name                = "NsbApi"
  config.api_base_url          = "/api/v1"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.validate = false
  config.use_cache = Rails.env.production?
end
