require 'sinatra/json'

class Application < Sinatra::Base

  configure :production, :development do
    enable :logging
  end

end