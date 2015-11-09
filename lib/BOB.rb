require "BOB/version"
require "BOB/element"
require "BOB/child_array"

module BOB
	# Your code goes here...
	def self.new(*args)
		BOB::Element.new(*args)
	end

	def self.data(*args)
		BOB::Element.method(:data)
	end
	def self.d(*args)
		BOB::Element.method(:d)
	end
end
