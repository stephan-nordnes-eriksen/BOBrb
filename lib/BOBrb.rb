require "BOBrb/version"
require "BOBrb/element"
require "BOBrb/child_array"

module BOBrb
	# Your code goes here...
	def self.new(*args)
		BOBrb::Element.new(*args)
	end

	def self.data(*args)
		BOBrb::Element.method(:data)
	end
	def self.d(*args)
		BOBrb::Element.method(:d)
	end
end
