source "https://rubygems.org"

gem "bootsnap", require: false
gem "devise", "~> 4.9"
gem "importmap-rails"
gem "jbuilder"
gem "omniauth-rails_csrf_protection"
gem "omniauth-steam"
gem "pg", "~> 1.1"
gem "propshaft" # The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "puma", ">= 5.0"
gem "rails", "~> 8.0.0"
gem "rexml"
gem "simple_form"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "view_component"

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "rspec-rails", "~> 7.0.0"
  gem "rubocop-rails-omakase", require: false
  gem "shoulda-matchers", "~> 6.0"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "rspec-its"
  gem "simplecov", require: false
  gem "webmock"
end
