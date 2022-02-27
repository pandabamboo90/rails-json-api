source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use Devise as authentication solution
gem "devise"
gem 'devise_token_auth', '>= 1.2.0', git: "https://github.com/lynndylanhurley/devise_token_auth"

# Authorization
gem "rolify"
gem "action_policy"

# Pagination
gem "will_paginate"
gem "api-pagination"

# Soft-delete
gem 'discard', '~> 1.2'

# Use Shrine as image uploader
gem "shrine", "~> 3.0"
gem "image_processing", "~> 1.8"

# For comparing time in Ruby
gem 'validates_overlap', github: 'pandabamboo90/validates_overlap'
gem 'validates_timeliness', '~> 6.0.0.alpha1'

# Use Fast JSON API serializer for Ruby Objects.
gem "oj"
gem 'jsonapi-serializer'
gem 'jsonapi.rb'

# Structure your apps seed data instead of having it all dumped into one large file
gem 'seedbank'

# For generating fake data
gem 'faker'

# Gems for logging system
gem 'amazing_print'
gem 'rails_semantic_logger'

# Automatic eager load
gem 'goldiloader'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # For testing sending mail in local
  gem "letter_opener"

  # Clean up migration files
  gem 'squasher', '>= 0.6.2'
  gem 'annotate'

  # Enforce coding style
  gem "standard"

  # Use Capistrano for deployment
  gem "capistrano"
  gem "capistrano-rails"
  gem "capistrano-bundler"
  gem "capistrano-rbenv"

  # For backup & replicate database
  gem "capistrano-db-tasks", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
