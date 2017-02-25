class LampController < ApplicationController
  def index
  	@status = Switch.get(:bedroom, :lamp)
  end

  def set_status
  	status = params.fetch("status", "false")
  	response = if Switch.to(:bedroom, :lamp, status)
  		         { success: true, status: status}
  		       else 
  		       	 { success: false, message: "Something went wrong!"}
  		       end
  	render json: response
  end
end
