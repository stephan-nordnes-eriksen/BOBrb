require 'spec_helper'

describe BOBrb do
  it 'has a version number' do
    expect(BOBrb::VERSION).not_to be nil
  end

  it 'renders basic div' do
    expect(BOBrb.new("div").s()).to eq("<div></div>")
  end

  # it 'renders complex element' do
  # 	expect(BOBrb.new("div",{test: "lol"}).do(["data"]).a("p",lambda{|d|self.insert("div",{a: d.height})}).s()).to eq("")
  # end


	it "div basic" do
		expect(BOBrb.new("div").toString() ).to eq("<div></div>")
	end
	it "div shorthand" do
		expect(BOBrb.new("div").s() ).to eq("<div></div>")
	end
	it "div with classs" do
		expect(BOBrb.new("div").classs("some_class").s() ).to eq("<div class=\"some_class\"></div>")
	end
	it "div with ID" do
		expect(BOBrb.new("div").id("some_id").s() ).to eq("<div id=\"some_id\"></div>")
	end
	it "div.some_class" do
		expect(BOBrb.new("div.some_class").s() ).to eq("<div class=\"some_class\"></div>")
	end
	it "div#some_id" do
		expect(BOBrb.new("div#some_id").s() ).to eq("<div id=\"some_id\"></div>")
	end
	it "div style" do
		expect(BOBrb.new("div").style("min-height: 10px;").s() ).to eq("<div style=\"min-height: 10px;\"></div>")
	end
	it "h1 content" do
		expect(BOBrb.new("h1").content("BOB is awesome! <3").s() ).to eq("<h1>BOB is awesome! <3</h1>")
	end
	it "div properties" do
		expect(BOBrb.new("div", {"data-BOB-is-cool" => "Yes it is", "data-very-cool"=> "indeed"}).s() ).to eq("<div data-BOB-is-cool=\"Yes it is\" data-very-cool=\"indeed\"></div>").or eq("<div data-very-cool=\"indeed\" data-BOB-is-cool=\"Yes it is\"></div>")
	end
	it "div append" do
		expect(BOBrb.new("div").append("span").s() ).to eq("<div></div><span></span>")
	end
	it "div prepend" do
		expect(BOBrb.new("div").prepend("span").s() ).to eq("<span></span><div></div>")
	end
	it "div insert" do
		expect(BOBrb.new("div").insert("span").s() ).to eq("<div><span></span></div>")
	end
	it "div append ID" do
		expect(BOBrb.new("div").append("span").id("some_id").s() ).to eq("<div></div><span id=\"some_id\"></span>")
	end
	it "div append up id" do
		expect(BOBrb.new("div").append("span").up().id("some_id").s() ).to eq("<div id=\"some_id\"></div><span></span>")
	end
	it "ul do with data" do
		expect(BOBrb.new("ul").do([1,2,3]).insert("li").content(BOBrb.data).s() ).to eq("<ul><li>1</li><li>2</li><li>3</li></ul>")
	end
	it "ul do with external data" do
		data = [1,2,3];
		expect( BOBrb.new("ul").do(data).insert("li", {"data-property" => BOBrb.data}).id(BOBrb.data).s() ).to eq("<ul><li data-property=\"1\" id=\"1\"></li><li data-property=\"2\" id=\"2\"></li><li data-property=\"3\" id=\"3\"></li></ul>")
	end
	# it "ul" do
	# 	expect(BOBrb.new("ul").do([1,2,3]).insert("li").up().id(BOBrb.data).s() //INVALID ).to eq(The BOBrb.data will not be set and you will get the output of: "<ul><li></li><li></li><li></li></ul>".)
	# end
	it "ul data mod lambda" do
		expect(BOBrb.new("ul").do([1,2,3]).insert("li").content(lambda{return BOBrb.data.call() + 2}).s() ).to eq("<ul><li>3</li><li>4</li><li>5</li></ul>")
	end
	it "data modifier external" do
		data_modifier = lambda{return BOBrb.data.call() + 2} #This should be changed to data_modifier = lambda{|data|return data + 2}
		expect(BOBrb.new("ul").do([1,2,3]).insert("li").content(data_modifier).s() ).to eq("<ul><li>3</li><li>4</li><li>5</li></ul>")
	end
	it 'Shorthand syntax:' do
		expect(BOBrb.new("div").i("img", {"src" => "some.png"}).u().d([1,2,3]).i("p.number").co(BOBrb.d).s()).to eq("<div><img src=\"some.png\" /><p class=\"number\">1</p><p class=\"number\">2</p><p class=\"number\">3</p></div>")
	end

	it 'pretty print' do
		expect(BOBrb.new("article").a("lol").i("photo").co("test").a("test2").i("price").co("200euro").pp()).to eq(%{<article>
</article>
<lol>
	<photo>
		test
	</photo>
	<test2>
		<price>
			200euro
		</price>
	</test2>
</lol>})
	end

	it 'tests style on child_element' do
		expect(BOBrb.new("div").do([1]).append("span").style("test").s() ).to eq("<div></div><span style=\"test\"></span>")
	end
	it 'tests style on child_element' do
		expect(BOBrb.new("div").do([1]).append("span").classs("test").s() ).to eq("<div></div><span class=\"test\"></span>")
	end
	it 'tests append on child_element' do
		expect(BOBrb.new("div").do([1]).append("span").append("test").s() ).to eq("<div></div><span></span><test></test>")
	end
	it 'tests prepend on child_element' do
		expect(BOBrb.new("div").do([1]).append("span").prepend("test").s() ).to eq("<div></div><test></test><span></span>")
	end
	it 'tests pretty Print on child_element' do
		expect(BOBrb.new("div").do([1]).append("span").prettyPrint() ).to eq("<div>\n</div>\n<span>\n</span>")
	end
	it "throws error when space is in identifier" do
		expect{BOBrb.new("di v").s() }.to raise_error(StandardError, "Invalid Element selector. \"di v\" contains \" \"(space). Only allowed is \"tag\", \"tag.class\", or \"tag#id\".")	
	end

	it "test with two prepends" do
		expect(BOBrb.new("div").prepend("span").prepend("test").s() ).to eq("<test></test><span></span><div></div>")
	end
end
