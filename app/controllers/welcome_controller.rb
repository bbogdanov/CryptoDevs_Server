class WelcomeController < ApplicationController
  def index
    hash = {
      greeting: 'Hello world'
    }
    render json: hash
  end
end
