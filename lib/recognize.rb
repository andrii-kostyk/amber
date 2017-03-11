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
      	on: { action: 'to', params: [:bedroom, :lamp, 'true'], response: { success: 'lamp is turned on' , error: "I cant turn on"} },
        off: { action: 'to', params: [:bedroom, :lamp, 'false'], response: { success: 'lamp is turned off', error: "I cant turn off"}},
        status: { action: 'get', params: [:bedroom, :lamp], response: { success: 'lamp is', error: "I cant retrieve status"}} 
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
            response_with_message(true, "#{perform[:response][:success]} #{action_response}")
         elsif action_response
            response_with_message(true, perform[:response][:success])
         else
            response_with_message(false, perform[:response][:error])
         end
      else
        { success: false, message: single('und') }
      end
    rescue
        { success: false, message: single('wrong') }
	  end

    def response_with_message status, text
      url = CloudApp.new('amber-cloud').tts(text)
      { success: status, message: url }
    end

    def single file
      "http://192.168.0.200/speech/#{file}.wav"
    end
	end
end