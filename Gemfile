# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

gem 'bundler'
gem 'rake'
gem 'sinatra'
gem 'sinatra-contrib'

gem 'dotenv'

gem 'sentry-raven'

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'minitest'
  gem 'mocha'
  gem 'rack-test'
end

group :production do
  gem 'puma'
end