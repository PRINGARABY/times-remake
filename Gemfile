source "https://rubygems.org"
ruby "~> 3.4.0"

gem "rails", "~> 8.1.3", ">= 8.1.3.1"
# Rails 8.1 passes JSON.parse options as a positional hash; JSON 3 removed that API.
gem "json", "< 3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Runs the Rails server and Tailwind watcher together through bin/dev.
  gem "foreman", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
