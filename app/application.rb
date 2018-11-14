require 'sinatra/json'
require 'sinatra/activerecord'

class Application < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  configure :production, :development do
    enable :logging
  end

  set :database, {
      adapter: ENV['DB_ADAPTER'],
      pool: ENV.fetch("MAX_THREADS") { 5 }.to_i,
      host: ENV['DB_HOST'],
      username: ENV['DB_USERNAME'],
      password: ENV['DB_PASSWORD'],
      database: ENV['DB_NAME']
  }

end