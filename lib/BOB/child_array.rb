module BOB
	class ChildArray
		def initialize (dataset, parent)
			@dataset = dataset
			@parent = parent
			@bobs = []
		end

		#No point in doing this on parent. Does not make sense to do ".do(data).id(BOB.data)"
		def content (content)
			self.co(content)
		end
		def co (content)
			for i in [0...@dataset.length]
				BOB._data = @dataset[i]
				@bobs[i].co(content) if @bobs[i]
			end
			return this
		end
		def style (style)
			self.st(style)
		end
		def st (style)
			for i in [0...@dataset.length]
				BOB._data = @dataset[i]
				@bobs[i].st(style) if @bobs[i]
			end
			return this
		end
		def class (object_class)
			self.cl(object_class)
		end
		def cl (object_class)
			for i in [0...@dataset.length]
				BOB._data = @dataset[i]
				@bobs[i].cl(object_class) if @bobs[i]
			end
			return this
		end
		def id (object_id)
			for i in [0...@dataset.length]
				BOB._data = @dataset[i]
				@bobs[i].id(object_id) if @bobs[i]
			end
			return this
		end
		def insert (data, options)
			self.i(data, options)
		end
		def i (data, options)
			for i in [0...@dataset.length]
				BOB._data = @dataset[i]
				if @bobs[i]
					@bobs[i] = @bobs[i].insert(data, options)
				else
					@bobs.push(@parent.insert(data, options))
				end
			end
					
			return this
		end
		def append (data, options)
			self.a(data, options)
		end
		def a (data, options)
			for i in [0...@dataset.length]
				BOB._data = @dataset[i]
				if @bobs[i]
					@bobs[i] = @bobs[i].a(data, options)
				else
					@bobs.push(@parent.a(data, options))
				end
			end
			return this
		end

		def prepend (data, options)
			self.p(data, options)
		end
		def p (data, options)
			for i in [0...@dataset.length]
				BOB._data = @dataset[i]
				if @bobs[i]
					@bobs[i] = @bobs[i].p(data, options)
				else
					@bobs.push(@parent.p(data, options))
				end
			end

			return this
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
			for bob in @bobs
				BOB._data = @dataset[i]
				if @bobs[i]
					@bobs[i] = @bobs[i].d(data)
				else
					@bobs.push(@parent.d(data))
				end
			end
				
			return this
		end
		def up
			self.u()
		end
		def u
			unless @bobs[0]
				BOB._data = null
				return @parent
			end
			for i in [0...@bobs.length]
				@bobs[i] = @bobs[i].u()
			end
			if @bobs[0] == @parent
				BOB._data = null
				return @parent
			else
				return this
			end
		end
	end
end