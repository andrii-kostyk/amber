class ConversationsController < ApplicationController
  def index
  end

  def recognize
  	command = params.fetch("command", "")
  	response = Gray::Analysis.perform(command)
  	render json: { success: response[:success], message: response[:message]}
  end
end
