# BOB

# build or bail
module BOB
	class Element
		attr_accessor :object_content, :parent
		@@data = nil
		
		def self.find(selector)
			#TODO: this selects an existing element, and append/prepend/inserts into that
		end
		def self.data
			return @@data
		end
		def self.data=(data)
			@@data = data
		end
		def self.d
			return @@data
		end
		def self.get_or_create_bob(data, options, parent)
			child_bob = nil
			if data.is_a?(Element)
				child_bob = data
			else
				child_bob = Element.new(data, options, parent)
			end
			return child_bob
		end

		def self.toVariable(data)
			if data.respond_to?(:call)
				return data.call
			else
				return data
			end
		end

		def initialize (selector, options=nil, parent=nil, preBob=nil, contentBob=nil, postBob=nil)
			if selector.include?(" ")
				raise StandardError, "Invalid Element selector. \"" + selector.to_s + "\" contains \" \"(space). Only allowed is \"tag\", \"tag.class\", or \"tag#id\"."
			end

			@parent = parent

			#Flatting so Element.data gets parsed out to the correct thing.
			@options = {}
			if options
				options.each do |key, value|
					@options[key] = Element.toVariable(value)
				end
			end

			@preBob = preBob
			@innerBob = contentBob
			@postBob = postBob

			@type = selector
			@object_class = nil
			@object_id = nil
			@object_content = ""
			@object_style = nil

			if selector.include?(".")
				@type, @object_class = selector.split(".")
			elsif selector.include?("#")
				@type, @object_id = selector.split("#")
			end
		end

		def content (content)
			self.co(content)
		end
		def co (content)
			child = self.i("")
			child.object_content = Element.toVariable(content)
			return self
		end
		def style (style)
			self.st(style)
		end
		def st (style)
			@object_style = Element.toVariable(style)
			return self
		end
		def classs (object_class)
			self.cl(object_class)
		end
		def cl (object_class)
			@object_class = Element.toVariable(object_class)
			return self
		end
		def id (object_id)
			@object_id = Element.toVariable(object_id)
			return self
		end
		def insert (data, options=nil)
			self.i(data,options)
		end
		def i (data, options=nil)
			child_bob = Element.get_or_create_bob(data, options, self)
			if @innerBob
				@innerBob.a(child_bob)
			else
				@innerBob = child_bob
			end
			return child_bob
		end
		def append (data, options=nil)
			self.a(data, options)
		end
		def a (data, options=nil)
			par = self
			par = @parent if @parent
			new_bob = Element.get_or_create_bob(data, options, par)
			if @postBob
				@postBob.a(new_bob)
			else
				@postBob = new_bob
			end
		end
		def prepend (data, options=nil)
			self.p(data, options)
		end
		def p (data, options=nil)
			par = self
			par = @parent if @parent
			new_bob = Element.get_or_create_bob(data, options, par)
			if @preBob
				@preBob.p(new_bob)
			else
				@preBob = new_bob
			end
		end
		def do (dataset)
			self.d(dataset)
		end
		def d (dataset)
			child_array = ChildArray.new(dataset, self)
			# @doData = dataset
			# @inDO = true
			return child_array
		end
		def up
			@parent
		end
		def u
			@parent
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
			#this makes the toString bubble to the top if it is cast on a sub-element
			if @parent
				return @parent.s(pretty)
			end
			
			#kill parents so they will print out.
			@innerBob.parent = nil if @innerBob
			@preBob.parent     = nil if @preBob
			@postBob.parent    = nil if @postBob

			prepend = ''
			append = ''
			printself = ''
			content_b = ''

			content_b = @innerBob.s(pretty) if @innerBob
			prepend = @preBob.s(pretty) if @preBob
			append = @postBob.s(pretty) if @postBob
			#TODO: Make special case for img (or those without content?) and no-type tag, which is pure text content.
			
			if @type != ""
				printself += '<' + @type + ' '
				@options.each do |key, value|
					unless key == 'style' && @object_style || key == 'id' && @object_id || key == 'class' && @object_class
						printself << key.to_s() + '="' + value.to_s() + '" '
					end
				end
				
				printself << 'class="' + @object_class.to_s() + '" ' if @object_class
				printself << 'id="'    + @object_id.to_s()    + '" ' if @object_id
				printself << 'style="' + @object_style.to_s() + '" ' if @object_style

				printself = printself[0..-2]
				closable = (["area",
							"base",
							"br",
							"col",
							"embed",
							"hr",
							"img",
							"input",
							"keygen",
							"link",
							"menuitem",
							"meta",
							"param",
							"source",
							"track",
							"wbr",
							"basefont",
							"bgsound",
							"frame",
							"isindex"].include?(@type))

				if closable && content_b == ''
					printself << ' />'
				else	
					if pretty
						if content_b && content_b != ""
							content_b = "\n\t" +  content_b.gsub("\n", "\n\t").to_s() + "\n"
						else
							content_b = "\n"
						end
					end
					printself.to_s() << '>' + content_b.to_s() + '</' + @type.to_s() + '>'
				end
			else
				#pure text element (no type)
				printself = @object_content #it should not have any innerBob as it is never exposed when we are setting object_content
			end
			if pretty
				prepend =  prepend + "\n\t" if prepend && prepend != ""
				printself = printself.gsub("\n", "\n\t") if prepend && prepend != ""
				append = "\n" + append if append && append != ""
			end
					
			
			return prepend.to_s() + printself.to_s() + append.to_s()
		end

		# Element.new("div",{test: "lol"}).do(["data"]).add("p",funtion(d){self.insert("div",{a: d.height})})

		# Element.new("ul",{class: "lol"})
		# 	.do(dataset)
		# 	.insert("li", {dataProp: Element.data}) #?
		# 		.content(Element.data)              #?
		# 	.insert("p")
		# 		.content("lol")
		# 	.up()
		# 	.up()
		# 	.insert("p")
		# 		.content("lol2")
		# 	.up()
		# 	.append("ul",{class: "shiet"})
		# 	.append("ul",{class: "shiet"})
		# 	.prepend("ul",{class: "shiet"})
		# 	.toString();

	end
end