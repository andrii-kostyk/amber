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
      	on: { action: 'to', params: [:bedroom, :lamp, 'true'], response: { success: 'Лампу включено' , error: "Я не можу включити лампу"} },
        off: { action: 'to', params: [:bedroom, :lamp, 'false'], response: { success: 'Лампу виключено', error: "Я не можу виключити лампу"}},
        status: { action: 'get', params: [:bedroom, :lamp], response: { success: 'Лампа ', error: "Я не можу отримати статус"}} 
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
         if action_response && action_response.kind_of?(String)
            _message = action_response == "ON" ? "включена" : "виключена"
            { success: true, message: "#{perform[:response][:success]} #{_message}" }
         elsif action_response
            { success: true, message: perform[:response][:success] }
         else
            { success: false, message: perform[:response][:error] }
         end
      else
        { success: false, message: "Я вас не розумію" }
      end
    rescue
        { success: false, message: "Щось пішло нетак" }
	  end
	end
end