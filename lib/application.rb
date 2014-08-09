require 'sinatra/base'

module Todo
  class Application < Sinatra::Base

    get '/' do
      'todo application'
    end

  end
end
