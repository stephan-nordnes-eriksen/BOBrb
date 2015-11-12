require "BOBrb/version"
require "BOBrb/element"
require "BOBrb/child_array"

module BOBrb
	@@mode = :html
	def self.new(*args)
		BOBrb::Element.new(*args)
	end

	def self.data(*args)
		BOBrb::Element.method(:data)
	end
	def self.d(*args)
		BOBrb::Element.method(:d)
	end
	def self.set_mode(mode=:html)
		#supported: :html and :xml
		#Will affect how the resulting output is formatted
		@@mode = mode
	end
	def self.get_mode
		@@mode
	end
end
