module Recognize

	DICTIONARY = {
		actions: [ 
			{name: 'включ', key:  'on'}, 
			{name: 'виключ', key: 'off'}, 
			{name: 'статус', key: 'status'}
		],
		devices: [
			{name: 'ламп', key:  'lamp'}
		]
	}.freeze

	COMMANDS = {
      lamp: {
      	on: { action: 'to', params: [:bedroom, :lamp, 'true'], response: { success: 'lamp is turned on' , error: "I can't turn on"} },
        off: { action: 'to', params: [:bedroom, :lamp, 'false'], response: { success: 'lamp is turned off', error: "I can't turn off"}},
        status: { action: 'get', params: [:bedroom, :lamp], response: { success: 'lamp is', error: "I can't retrieve status"}} 
      }
	}.freeze

	class << self
		def parse command
			action = ''
			device = ''
            DICTIONARY[:actions].each { |item| action = item[:key] if command.match(item[:name]) }
            DICTIONARY[:devices].each { |item| device = item[:key] if command.match(item[:name]) }
            perform = COMMANDS.fetch(device.to_sym, {}).fetch(action.to_sym, nil)

            if perform
               action_response = Switch.send(perform[:action], *perform[:params])
               if action_response && action_response.kind_of?(String )
               	  { success: true, message: "#{perform[:response][:success]} #{action_response}" }
               elsif action_response
               	  { success: true, message: perform[:response][:success] }
               else
               	  { success: false, message: perform[:response][:error] }
               end
            else
            	{ success: false, message: "i dont understand you" }
            end
        rescue
            { success: false, message: "Something went wrong" }
	    end
	end
end