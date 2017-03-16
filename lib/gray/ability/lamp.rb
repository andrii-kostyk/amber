module Gray
  module Ability
    class Lamp
      def initialize data, additional
      	@data = data
      	@additional = additional
      	@_method = fetch_method
      end

      def perform
        self.send(@_method)
      end

      def on
      	response = Switch.to(:bedroom, :lamp, 'true')
      	if response
          { success: true, message: 'Лампу включено' }
        else
          { success: false, message: 'Я не можу включити лампу' }
        end
      end

      def off
      	response = Switch.to(:bedroom, :lamp, 'false')
      	if response
          { success: true, message: 'Лампу виключено' }
        else
          { success: false, message: 'Я не можу виключити лампу' }
        end
      end

      def status
        response = Switch.get(:bedroom, :lamp)
      	if response
      	   _message = response && response == "ON" ? "Лампа включена" : "Лампа виключена"
          { success: true, message: _message }
        else
          { success: false, message: 'Я не можу отримати статус' }
        end
      end

      def unknown
      	{ success: false, message: 'Я не розумію що робити з лампою' }
      end

      private

      def fetch_method
      	_method = nil
      	@data.each do |item|
      	  if item[:type] == 'action' && self.respond_to?(item[:key].to_sym)
            _method ||= item[:key]
          end
      	end
      	_method ||= 'unknown'
      end
    end
  end
end