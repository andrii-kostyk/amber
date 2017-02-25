require 'net/http'

module Switch
	DEVICES_BY_ROOM = {
		bedroom: {
			lamp: {
				url: 'http://192.168.0.201'
			} 
		}

	}.freeze

	class << self
		def get room, device
          url = "#{DEVICES_BY_ROOM[room][device][:url]}/status"
          response = send_request(url)
          response && response["success"] == "true" && response["status"] == "true" ? "ON" : "OFF"
        rescue
          "OFF"
		end

		def to room, device, status
		  url = "#{DEVICES_BY_ROOM[room][device][:url]}/set?status=#{status == 'true' ? 'on' : 'off'}"
	      response = send_request(url)
	      response && response["success"] == "true"
        rescue
          false
		end

		private

		def send_request destination
			response = Net::HTTP.get(URI.parse(destination))
			ActiveSupport::JSON.decode(response)
		rescue
           false
		end
    end
end