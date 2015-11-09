# BOB

# build or bail
module BOB
	class BOB
		@@data = nil
		
		def self.find(selector)
			#TODO: this selects an existing element, and append/prepend/inserts into that
		end
		def self.data
			return @@data
		end
		def self.d
			return @@data
		end
		def self.get_or_create_bob(data, options, parent)
			child_bob = null
			if data instanceof BOB
				child_bob = data
			else
				child_bob = BOB.new(data, options, parent)
			end
			return child_bob
		end

		def self.toVariable(data)
			if typeof data is 'function'
				return data()
			else
				return data
			end
		end

		def intitialize (selector, options, parent=null, preBob=null, contentBob=null, postBob=null)
			if selector.indexOf(" ") > -1
				console.error("Invalid BOB selector. \"" + selector + "\" contains \" \"(space). Only allowed is \"tag\", \"tag.class\", or \"tag#id\".")
				return "Invalid selector. See console log for more details."
			end

			@parent = parent

			#Flatting so BOB.data gets parsed out to the correct thing.
			@options = {}
			if options
				options.each do |key, value|
					@options[key] = BOB.toVariable(value)
				end
			end

			@preBob = preBob
			@innerBob = contentBob
			@postBob = postBob

			@type = selector
			@object_class = null
			@object_id = null
			@object_content = ""
			@object_style = null

			if selector.indexOf(".") > -1
				@type, @object_class = selector.split(".")
			elsif selector.indexOf("#") > -1
				@type, @object_id = selector.split("#")
			end
		end

		def content (content)
			self.co(content)
		end
		def co (content)
			child = self.i("")
			child.object_content = BOB.toVariable(content)
			return self
		end
		def style (style)
			self.st(style)
		end
		def st (style)
			@object_style = BOB.toVariable(style)
			return self
		end
		def class (object_class)
			self.cl(object_class)
		end
		def cl (object_class)
			@object_class = BOB.toVariable(object_class)
			return self
		end
		def id (object_id)
			@object_id = BOB.toVariable(object_id)
			return self
		end
		def insert (data, options)
			self.i(data,options)
		end
		def i (data, options)
			child_bob = BOB.get_or_create_bob(data, options, self)
			if @innerBob
				@innerBob.a(child_bob)
			else
				@innerBob = child_bob
			end
			return child_bob
		end
		def append (data, options)
			self.a(data, options)
		end
		def a (data, options)
			par = self
			par = @parent if @parent
			new_bob = BOB.get_or_create_bob(data, options, par)
			if @postBob
				@postBob.a(new_bob)
			else
				@postBob = new_bob
			end
		end
		def prepend (data, options)
			self.p(data, options)
		end
		def p (data, options)
			par = self
			par = @parent if @parent
			new_bob = BOB.get_or_create_bob(data, options, par)
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
			@innerBob.parent = null if @innerBob
			@preBob.parent     = null if @preBob
			@postBob.parent    = null if @postBob

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
						printself += key + '="' + value + '" '
					end
				end
				
				printself += 'class="' + @object_class + '" ' if @object_class
				printself += 'id="'    + @object_id    + '" ' if @object_id
				printself += 'style="' + @object_style + '" ' if @object_style

				printself = printself.slice(0, -1)
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
							"isindex"].indexOf(@type) != -1)

				if closable && content_b == ''
					printself += ' />'
				else	
					if pretty
						if content_b
							content_b = "\n\t" +  content_b.split("\n").join("\n\t") + "\n"	
						else
							content_b = "\n"
						end
					end
					printself += '>' + content_b + '</' + @type + '>'
				end
			else
				#pure text element (no type)
				printself = @object_content #it should not have any innerBob as it is never exposed when we are setting object_content
			end
			if pretty
				prepend =  prepend + "\n\t" if prepend
				printself = printself.split("\n").join("\n\t") if prepend
				append = "\n" + append if append
			end
					
			
			return prepend + printself + append
		end

		# BOB.new("div",{test: "lol"}).do(["data"]).add("p",funtion(d){self.insert("div",{a: d.height})})

		# BOB.new("ul",{class: "lol"})
		# 	.do(dataset)
		# 	.insert("li", {dataProp: BOB.data}) #?
		# 		.content(BOB.data)              #?
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