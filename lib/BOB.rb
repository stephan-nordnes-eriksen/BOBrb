require "BOB/version"
require "BOB/element"
require "BOB/child_array"

module BOB
	# Your code goes here...
	def self.new(*args)
		BOB::Element.new(*args)
	end

	def self.data(*args)
		BOB::Element.data(*args)
	end
	def self.d(*args)
		BOB::Element.d(*args)
	end
end
