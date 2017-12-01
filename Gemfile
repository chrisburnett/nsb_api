source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# AASM for job/assignment state machine
gem 'aasm'
# file uploads
gem 'carrierwave'
# auth tokens
gem 'jwt'
# postgres
gem 'pg'
gem 'bcrypt', '~> 3.1.7'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
gem 'cocoon'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# slim templates
gem 'slim-rails'
gem 'coffee-rails'

# bootstrap for admin page
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-datatables-rails'
gem 'ajax-datatables-rails', git: 'https://github.com/jbox-web/ajax-datatables-rails.git'

gem 'turbolinks'
gem 'font-awesome-rails'
# auditing/versioning
gem 'paper_trail'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'

# API documentation generator
gem 'apipie-rails'

gem 'rpush' 
gem 'net-http-persistent', '< 3' # v3.0.0 breaks Rpush
gem 'fog-aws'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner'
  gem 'pry'
  gem 'pry-byebug'
  gem 'faker'
  gem 'mocha'
  gem 'rails-erd'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
