# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

gem 'bundler'
gem 'rake'
gem 'sinatra'
gem 'sinatra-contrib'

gem 'pg'
gem 'activerecord'
gem 'sinatra-activerecord'

gem 'dotenv'

gem 'sentry-raven'

gem 'shoryuken'
gem 'aws-sdk-sqs'

gem 'DMAonline-Warden-JWT', :github => 'DMAonline/dmaonline-warden-jwt', :branch => 'logging'

gem 'simplecov', require: false, group: :test
gem 'minitest-ci', require: false, group: :test

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'minitest'
  gem 'mocha'
  gem 'rack-test'
  gem 'database_cleaner'
end

group :production do
  gem 'puma'
end