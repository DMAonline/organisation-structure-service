require_relative '../app/application'

module Api

  class FailureApp < ::Application

    get '/unauthenticated' do
      status 401
      response = {status: {code: 401, message: "Invalid authentication token"}}
      json response
    end

  end

end