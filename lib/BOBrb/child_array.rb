module BOBrb
	class ChildArray
		def initialize (dataset, parent)
			@dataset = dataset
			@parent = parent
			@bobs = []
		end

		#No point in doing this on parent. Does not make sense to do ".do(data).id(BOBrb::Element.data)"
		def content (content)
			self.co(content)
		end
		def co (content)
			@dataset.each_with_index do |item, i|
				BOBrb::Element.data = item
				@bobs[i].co(content) if @bobs[i]
			end
			return self
		end
		def style (style)
			self.st(style)
		end
		def st (style)
			@dataset.each_with_index do |item, i|
				BOBrb::Element.data = item
				@bobs[i].st(style) if @bobs[i]
			end
			return self
		end
		def classs (object_class)
			self.cl(object_class)
		end
		def cl (object_class)
			@dataset.each_with_index do |item, i|
				BOBrb::Element.data = item
				@bobs[i].cl(object_class) if @bobs[i]
			end
			return self
		end
		def id (object_id)
			@dataset.each_with_index do |item, i|
				BOBrb::Element.data = item
				@bobs[i].id(object_id) if @bobs[i]
			end
			return self
		end
		def insert (data, options=nil)
			self.i(data, options)
		end
		def i (data, options=nil)
			@dataset.each_with_index do |item, i|
				BOBrb::Element.data = item
				if @bobs[i]
					@bobs[i] = @bobs[i].insert(data, options)
				else
					@bobs.push(@parent.insert(data, options))
				end
			end
					
			return self
		end
		def append (data, options=nil)
			self.a(data, options)
		end
		def a (data, options=nil)
			@dataset.each_with_index do |item, i|
				BOBrb::Element.data = item
				if @bobs[i]
					@bobs[i] = @bobs[i].a(data, options)
				else
					@bobs.push(@parent.a(data, options))
				end
			end
			return self
		end

		def prepend (data, options=nil)
			self.p(data, options)
		end
		def p (data, options=nil)
			@dataset.each_with_index do |item, i|
				BOBrb::Element.data = item
				if @bobs[i]
					@bobs[i] = @bobs[i].p(data, options)
				else
					@bobs.push(@parent.p(data, options))
				end
			end

			return self
		end
		def prettyPrint
			self.pp()
		end
		def pp
			self.s(true)
		end
		def toString
			self.s()
		end
		def s (pretty = false)
			if @parent
				return @parent.s(pretty)
			else
				html_string = ""
				for bob in @bobs
					bob.parent = false
					html_string += bob.s(pretty)
				end
				return html_string
			end
		end

		#TODO: do(data).do(data2) does not behave correctly
		def do (data)
			self.d(data)
		end
		def d (data)
			@bobs.each_with_index do |bob, i|
				BOBrb::Element.data = item
				if @bobs[i]
					@bobs[i] = @bobs[i].d(data)
				else
					@bobs.push(@parent.d(data))
				end
			end
				
			return self
		end
		def up
			self.u()
		end
		def u
			unless @bobs[0]
				BOBrb::Element.data = nil
				return @parent
			end
			@bobs.each_with_index do |bob, i|
				@bobs[i] = @bobs[i].u()
			end
			if @bobs[0] == @parent
				BOBrb::Element.data = nil
				return @parent
			else
				return self
			end
		end
	end
end