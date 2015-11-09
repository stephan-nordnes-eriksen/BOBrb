require 'spec_helper'

describe BOB do
  it 'has a version number' do
    expect(BOB::VERSION).not_to be nil
  end

  it 'renders basic div' do
    expect(BOB.new("div").s()).to eq("<div></div>")
  end

  # it 'renders complex element' do
  # 	expect(BOB.new("div",{test: "lol"}).do(["data"]).a("p",lambda{|d|self.insert("div",{a: d.height})}).s()).to eq("")
  # end


	it "div basic" do
		expect(BOB.new("div").toString() ).to eq("<div></div>")
	end
	it "div shorthand" do
		expect(BOB.new("div").s() ).to eq("<div></div>")
	end
	it "div with classs" do
		expect(BOB.new("div").classs("some_class").s() ).to eq("<div class=\"some_class\"></div>")
	end
	it "div with ID" do
		expect(BOB.new("div").id("some_id").s() ).to eq("<div id=\"some_id\"></div>")
	end
	it "div.some_class" do
		expect(BOB.new("div.some_class").s() ).to eq("<div class=\"some_class\"></div>")
	end
	it "div#some_id" do
		expect(BOB.new("div#some_id").s() ).to eq("<div id=\"some_id\"></div>")
	end
	it "div style" do
		expect(BOB.new("div").style("min-height: 10px;").s() ).to eq("<div style=\"min-height: 10px;\"></div>")
	end
	it "h1 content" do
		expect(BOB.new("h1").content("BOB is awesome! <3").s() ).to eq("<h1>BOB is awesome! <3</h1>")
	end
	it "div properties" do
		expect(BOB.new("div", {"data-BOB-is-cool" => "Yes it is", "data-very-cool"=> "indeed"}).s() ).to eq("<div data-BOB-is-cool=\"Yes it is\" data-very-cool=\"indeed\"></div>").or eq("<div data-very-cool=\"indeed\" data-BOB-is-cool=\"Yes it is\"></div>")
	end
	it "div append" do
		expect(BOB.new("div").append("span").s() ).to eq("<div></div><span></span>")
	end
	it "div prepend" do
		expect(BOB.new("div").prepend("span").s() ).to eq("<span></span><div></div>")
	end
	it "div insert" do
		expect(BOB.new("div").insert("span").s() ).to eq("<div><span></span></div>")
	end
	it "div append ID" do
		expect(BOB.new("div").append("span").id("some_id").s() ).to eq("<div></div><span id=\"some_id\"></span>")
	end
	it "div append up id" do
		expect(BOB.new("div").append("span").up().id("some_id").s() ).to eq("<div id=\"some_id\"></div><span></span>")
	end
	it "ul do with data" do
		expect(BOB.new("ul").do([1,2,3]).insert("li").content(BOB.data).s() ).to eq("<ul><li>1</li><li>2</li><li>3</li></ul>")
	end
	it "ul do with external data" do
		data = [1,2,3];
		expect( BOB.new("ul").do(data).insert("li", {"data-property" => BOB.data}).id(BOB.data).s() ).to eq("<ul><li data-property=\"1\" id=\"1\"></li><li data-property=\"2\" id=\"2\"></li><li data-property=\"3\" id=\"3\"></li></ul>")
	end
	# it "ul" do
	# 	expect(BOB.new("ul").do([1,2,3]).insert("li").up().id(BOB.data).s() //INVALID ).to eq(The BOB.data will not be set and you will get the output of: "<ul><li></li><li></li><li></li></ul>".)
	# end
	it "ul data mod lambda" do
		expect(BOB.new("ul").do([1,2,3]).insert("li").content(lambda{return BOB.data.call() + 2}).s() ).to eq("<ul><li>3</li><li>4</li><li>5</li></ul>")
	end
	it "data modifier external" do
		data_modifier = lambda{return BOB.data.call() + 2} #This should be changed to data_modifier = lambda{|data|return data + 2}
		expect(BOB.new("ul").do([1,2,3]).insert("li").content(data_modifier).s() ).to eq("<ul><li>3</li><li>4</li><li>5</li></ul>")
	end
	it 'Shorthand syntax:' do
		expect(BOB.new("div").i("img", {"src" => "some.png"}).u().d([1,2,3]).i("p.number").co(BOB.d).s()).to eq("<div><img src=\"some.png\" /><p class=\"number\">1</p><p class=\"number\">2</p><p class=\"number\">3</p></div>")
	end

	it 'pretty print' do
		expect(BOB.new("article").a("lol").i("photo").co("test").a("test2").i("price").co("200euro").pp()).to eq(%{<article>
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

end
