module Gray
  class Analysis
  	def initialize heard, additional
  	  @heard = heard || ""
  	  @additional = additional
  	end

  	def self.perform heard = '', additional = nil
  	  self.new(heard, additional).perform
  	end

  	def perform
  	  essence = Gray::Heard.parse @heard
  	  @ability = Gray::Association.build_from essence, @additional
  	  @ability.perform
  	end
  end
end