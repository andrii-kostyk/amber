module Gray
  class Heard

    DICTIONARY = [ 
		{name: 'включ', key:  'on', type: 'action'},
		{name: 'увімкн', key:  'on', type: 'action'},
		{name: 'вимкн', key:  'off', type: 'action'}, 
		{name: 'виключ', key: 'off', type: 'action'}, 
		{name: 'статус', key: 'status', type: 'action'},
		{name: 'ламп', key:  'lamp', type: 'ability'}
	].freeze

    def initialize text
      @text = text
    end

  	def self.parse text
  	  self.new(text).perform
  	end

  	def perform
  	  essence = []
  	  DICTIONARY.each do |item|
  	  	essence << item if @text.match(item[:name])
  	  end
  	  return essence
  	end
  end
end