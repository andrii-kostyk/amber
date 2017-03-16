module Gray
  module Ability
  	class Unknown
  	  def initialize data, additional
      	@data = data
      	@additional = additional
      end

      def perform
      	{ success: false, message: "Я вас не розумію" }
      end
  	end
  end
end