class ConversationsController < ApplicationController
  def index
  end

  def recognize
  	command = params.fetch("command", "")
  	response = Recognize.parse(command)
  	render json: { success: response[:success], message: response[:message]}
  end

  def client
  	command = "chromium-browser 'https://192.168.0.200:3000'"
  	system(command)
  end
end
