#BOB
BOB is a simple and powerfull ruby pipe system for building complex XML and HTML structures. 

![BOB](/BOB.png?raw=true)

[![Build Status](https://travis-ci.org/stephan-nordnes-eriksen/BOBrb.svg)](https://travis-ci.org/stephan-nordnes-eriksen/BOBrb)
[![Code Climate](https://codeclimate.com/github/stephan-nordnes-eriksen/BOBrb/badges/gpa.svg)](https://codeclimate.com/github/stephan-nordnes-eriksen/BOBrb)
[![Test Coverage](https://codeclimate.com/github/stephan-nordnes-eriksen/BOBrb/badges/coverage.svg)](https://codeclimate.com/github/stephan-nordnes-eriksen/BOBrb/coverage)
[![Gem Version](https://badge.fury.io/rb/BOBrb.svg)](https://badge.fury.io/rb/BOBrb)

##Install:
```ruby

	require "BOBrb"
```

###Gem
    gem install BOBrb

##Usage:
BOB is a pipe system for generating html structures.

###TL;DR
```ruby

	BOB.new("div").toString() #=> "<div></div>"
	BOB.new("div").s() #=> "<div></div>"
	BOB.new("div").classs("some_class").s() #=> "<div class=\"some_class\"></div>" #NOTICE CLASSS, with three "s"-es. This is because ruby has defined the .class method.
	BOB.new("div").id("some_id").s() #=> "<div id=\"some_id\"></div>"
	BOB.new("div.some_class").s() #=> "<div class=\"some_class\"></div>"
    BOB.new("div#some_id").s() #=> "<div id=\"some_id\"></div>"
    BOB.new("div").style("min-height: 10px;").s() #=> "<div style=\"min-height: 10px;\"></div>"
    BOB.new("h1").content("BOB is awesome! <3").s() #=> "<h1>BOB is awesome! <3</h1>"
    BOB.new("div", {"data-BOB-is-cool": "Yes it is", "data-very-cool": "indeed"}).s() #=> "<div data-BOB-is-cool="Yes it is" data-very-cool="indeed"></div>"
    BOB.new("div").append("span").s() #=> "<div></div><span></span>"
    BOB.new("div").prepend("span").s() #=> "<span></span><div></div>"
	BOB.new("div").insert("span").s() #=> "<div><span></span></div>"
    BOB.new("div").append("span").id("some_id").s() #=> "<div></div><span id=\"some_id\"></span>"
    BOB.new("div").append("span").up().id("some_id").s() #=> "<div id=\"some_id\"></div><span></span>"
    BOB.new("ul").do([1,2,3]).insert("li").content(BOB.data).s() #=> <ul><li>1</li><li>2</li><li>3</li></ul>
    data = [1,2,3]; BOB.new("ul").do(data).insert("li", {"data-property": BOB.data}).id(BOB.data).s() #=> <ul><li id="1" data-property="1"></li><li id="2" data-property="2"></li><li id="3" data-property="3"></li></ul>
    BOB.new("ul").do([1,2,3]).insert("li").up().id(BOB.data).s() //INVALID #=> The BOB.data will not be set and you will get the output of: "<ul><li></li><li></li><li></li></ul>".
    BOB.new("ul").do([1,2,3]).insert("li").content(lambda{return BOB.data() + 2}).s() #=> <ul><li>3</li><li>4</li><li>5</li></ul>
    data_modifier = lambda{return BOB.data() + 2}; BOB.new("ul").do([1,2,3]).insert("li").content(data_modifier).s() #=> <ul><li>3</li><li>4</li><li>5</li></ul>
    
    //Shorthand syntax:
    BOB.new("div").i("img", {"src":"some.png"}).u().d([1,2,3]).i("p.number").co(BOB.d).s() #=> "<div><img src="some.png" /><p class="number">1</p><p class="number">2</p><p class="number">3</p></div>"
```
[Go to shorthand syntax section](#shorthand)

###Building a simple tag:
```ruby

    BOB.new("div").toString() 
    #=> "<div></div>"
```
You can also use the shorthand method "s". For a full list see [the shorthand section](#shorthand)

```ruby

    BOB.new("div").s()
    #=> "<div></div>"
```

###Adding IDs and classes
```ruby

	BOB.new("div").classs("some_class").s()
    #=> "<div class=\"some_class\"></div>"
    BOB.new("div").id("some_id").s()
    #=> "<div id=\"some_class\"></div>"
```

This can also be done with the shorthand selector style:
```ruby

    BOB.new("div.some_class").s()
    #=> "<div class=\"some_class\"></div>"
    BOB.new("div#some_id").s()
    #=> "<div id=\"some_class\"></div>"
```

###Adding styles, content, and custom attributes
```ruby

	BOB.new("div").style("min-height: 10px;").s()
    #=> "<div style=\"min-height: 10px;\"></div>"
    BOB.new("h1").content("BOB is awesome! <3").s()
    #=> "<h1>BOB is awesome! <3</h1>"
    BOB.new("div", {"data-BOB-is-cool": "Yes it is", "data-very-cool": "indeed"}).s()
    #=> "<div data-BOB-is-cool="Yes it is" data-very-cool="indeed"></div>"
```

###Building and appending/prepending tags:
```ruby

    BOB.new("div").append("span").s()
    #=> "<div></div><span></span>"
    BOB.new("div").prepend("span").s()
    #=> "<span></span><div></div>"
```

###Building with inserting tags:
```ruby

    BOB.new("div").insert("span").s()
    #=> "<div><span></span></div>"
```

###Handling basic nesting
When appending, prepending, or inserting you will effectively branch downwards, meaning that the latest element is your current active. Example:

```ruby

	BOB.new("div").append("span").id("some_id").s()
	#=> "<div></div><span id=\"some_id\"></span>"
```

In this simlpe example we see that it is the `span` that receives the `id`, not the div. If we wanted to affect the `div` in stead (in this trivial, nonsensical, example), we would do:

```ruby

	BOB.new("div").append("span").up().id("some_id").s()
	#=> "<div id=\"some_id\"></div><span></span>"	
```

We effectively traversed backwards, or up, the stack. This is the basics of managing nesting and branching. Let's have a look at how to build usefull branches.

**It is very improtant to keep track of what is "in focus" when you are applying the next pipe.**


###Branching out
Say you want HTML that looks like this:

```ruby

    <ul><li>1</li><li>2</li><li>3</li></ul>
```

To do such branching, without having to re-write all parts manually, you can use the `do` method:

```ruby

    BOB.new("ul").do([1,2,3]).insert("li").content(BOB.data).s()
    #=> <ul><li>1</li><li>2</li><li>3</li></ul>
```

Here you see `BOB.data` which is a special variable which represend the individal data points when the chain in being executed. It can be used for anything within the scope of the `do`, eg.

```ruby

	data = [1,2,3]
    BOB.new("ul").do(data).insert("li", {"data-property": BOB.data}).id(BOB.data).s()
    #=> <ul><li id="1" data-property="1"></li><li id="2" data-property="2"></li><li id="3" data-property="3"></li></ul>
```

However, if you use the `up` command and go out of the scope of `do`, `BOB.data` might not work. The behaviour is undefined so errors and/or strange behaviour might occur. Eg:

```ruby

	BOB.new("ul").do([1,2,3]).insert("li").up().id(BOB.data).s() //INVALID
    #=> The BOB.data will not be set and you will get the output of: "<ul><li></li><li></li><li></li></ul>".
```

###Processing data and BOB.data
BOB.data is a function, so **you cannot manipulate `BOB.data` directly.**

It is adviced to do the data manipulation prior to the `do` pipe. However it is possible to manipulate BOB.data inline like this:

```ruby

	BOB.new("ul").do([1,2,3]).insert("li").content(lambda{return BOB.data() + 2}).s()
    #=> <ul><li>3</li><li>4</li><li>5</li></ul>
    //Or you can predefine a set of manipulations
    data_modifier = lambda{return BOB.data() + 2}
    BOB.new("ul").do([1,2,3]).insert("li").content(data_modifier).s()
    #=> <ul><li>3</li><li>4</li><li>5</li></ul>
```


<a name="shorthand"></a>
###Short hand syntax
Writing out these pipes can be tiresom if you are building big and complex structures, so you can utilize these shorthand methods.

Long Version | Short Version
------------ | -------------
.insert   | .i
.append   | .a
.prepend  | .p
.content  | .co
.style    | .st
.classs   | .cl
.id       | .id
.style    | .st
.toString | .s
.do       | .d
.up       | .u
BOB.data  | BOB.d

Now you can get tight and cozy syntax like this:

```ruby

	BOB.new("div").i("img", {"src":"some.png"}).u().d([1,2,3]).i("p.number").co(BOB.d).s()
	#=> "<div><img src="some.png"></img><p class="number">1</p><p class="number">2</p><p class="number">3</p></div>"
```

###Some complex examples
Better examples coming

```ruby
	
	data = ["Team member1", "team member2", "team member3"]
	BOB.new("ul").do(data).insert("li.team").content(BOB.data).s()
	#=> "<ul><li class="team">Team member1</li><li class="team">team member2</li><li class="team">team member3</li></ul>"

	BOB.new("div#wrapper").insert("div#searchbar").up().insert("footer").do(["team","contact","buy"]).insert("h2").content(BOB.data).s()
	#=> "<div id="wrapper"><div id="searchbar"></div><footer><h2>team</h2><h2>contact</h2><h2>buy</h2></footer></div>"

	BOB.new("div#wrapper").insert("div#searchbar").up().insert("footer").do(["team","contact","buy"]).insert("h2",{"onclick": lambda{return ("alert('" + BOB.data() + "');") }}).content(BOB.data).s()
	#=> "<div id="wrapper"><div id="searchbar"></div><footer><h2 onclick="alert('team');">team</h2><h2 onclick="alert('contact');">contact</h2><h2 onclick="alert('buy');">buy</h2></footer></div>"

	BOB.new("div#wrapper").insert("div#searchbar").up().insert("footer").do(["team","contact","buy"]).insert("h2",{"onclick": lambda{return ("alert('" + BOB.data() + "');") }}).content(BOB.data).up().up().prepend("a",{"href": "http://www.google.com"}).content("google").s()
	#=> "<a href="http://www.google.com">google</a><div id="wrapper"><div id="searchbar"></div><footer><h2 onclick="alert('team');">team</h2><h2 onclick="alert('contact');">contact</h2><h2 onclick="alert('buy');">buy</h2></footer></div>"
```

##Important notes:
Please help contribute to this project. It is brand new, and there are probably loads of features that can be added. 

###Planned features
 - Adding nested data-aquisition data, eg: BOB.new("div").do(["a", "b"]).do([1,2]).in("a").classs(BOB.data[0]).co(BOB.data[1])
 #=> <div><a class="a">1</a><a class="a">2</a><a class="b">1</a><a class="b">2</a></div>

##License
MIT
