module Gray
  class Association
    def initialize essence, additional
      @essence = essence
      @additional = additional
    end

  	def self.build_from essence, additional
  	  self.new(essence, additional).perform
  	end

  	def perform
  	  ability = fetch_ability
  	  _ability = build_ability_object ability
      return _ability.new @essence, @additional
  	end

  	private

  	def fetch_ability
  	  ability = nil

  	  abilitys = {
  	  	'lamp' => 'Lamp'
  	  }

  	  @essence.each do |item|
        if item[:type] == 'ability' && abilitys.has_key?(item[:key])
          ability ||= abilitys[item[:key]]
        end
  	  end

  	  ability || 'Unknown'
  	end

  	def build_ability_object ability
  	  _ability = 'Gray::Ability::' + ability
  	  _ability.split('::').inject(Object) {|o,c| o.const_get c}
  	end
  end
end