require 'spec_helper'

describe 'DirectoryTag' do

  let(:doc) { Nokogiri::HTML::DocumentFragment.parse generated_html }

  let(:generated_html) {
    info = { :registers => { :site => site } }
    converter = site.converters.find { |c| c.class == Jekyll::Converters::Markdown }
    template = Liquid::Template.parse(post)
    result = template.render({}, info)
    converter.convert(result)
  }

  let(:site)            { Jekyll::Site.new(configuration) }

  let(:configuration)   {
    Jekyll.configuration(
      'source' => source_dir,
      'plugins_dir' => plugins_dir,
      'markdown' => 'kramdown' # marku has trouble with img titles
    )
  }

  let(:post) { <<-post }
{% directory #{parameters} %}
#{content}
{% enddirectory %}
post

  let(:parameters) { "path: images" }
  let(:content) { %q* - {{ file.name }} * }

  before do
    Dir.chdir source_dir
    FileUtils.mkdir_p 'images'
  end

  after { FileUtils.rm_rf   'images' }

  describe "parameters" do
    before do
      FileUtils.touch   'images/2008-08-08-alpha-team.jpg'
      FileUtils.touch   'images/2009-09-09-bravo-squad.jpg'
      FileUtils.touch   'images/2010-10-10-charlie-company.jpg'
    end

    let(:content) { %q* - {{ file.date | date: "%F" }} * }
    let(:dates)   { %w(2008-08-08 2009-09-09 2010-10-10) }

    it "should be sorted by date" do
      expect(doc.css('li').map(&:text).map(&:strip)).to eq(dates)
    end

    context "with reverse: true" do
      let(:parameters) { "path: images reverse: true" }

      it "should be sorted by date" do
        expect(doc.css('li').map(&:text).map(&:strip)).to eq(dates.reverse)
      end
    end

    context "with exclude: regex" do
      let(:parameters) { "path: images exclude: c.ar" }

      it "ignores the matching files" do
        expect(doc.css('li').map(&:text).map(&:strip)).to eq(%w(2008-08-08 2009-09-09))
      end
    end
  end

  describe "directory with nested dirs" do
    before do
      FileUtils.mkdir_p 'images/icons'
      FileUtils.mkdir_p 'images/other'
      FileUtils.mkdir_p 'images/pictures'
    end

    it "should show items without extensions" do
      expect(doc.css('li').map(&:text).map(&:strip)).to eq(%w(icons other pictures))
    end
  end

  describe "path" do
    before do
      FileUtils.touch   'images/2008-08-08-alpha-team.jpg'
      FileUtils.touch   'images/2009-09-09-bravo-squad.jpg'
      FileUtils.touch   'images/2010-10-10-charlie-company.jpg'
    end

    let(:content) { %q* - {{ file.date | date: "%F" }} * }
    let(:dates)   { %w(2008-08-08 2009-09-09 2010-10-10) }

    context "when the path is a variable" do
      let(:parameters) { "path: some_path_variable" }

      let(:post) { <<-post }
{% assign some_path_variable = 'images' %}
{% directory #{parameters} %}
#{content}
{% enddirectory %}
post

      it "should evaluate the variable" do
        expect(doc.css('li').map(&:text).map(&:strip)).to eq(dates)
      end

    end

    context "when accessing a directory out of the project root" do
      let(:parameters) { "path: ../ " }

      it "should throw an exception" do
        target_dir = File.expand_path File.join(source_dir, "../")
        expect(doc.css('p').map(&:text)).to include("Liquid error: Listed directory ‘#{target_dir}’ cannot be out of jekyll root")
      end
    end
  end

  describe "file object" do
    let(:content)    { %q* ![{{ file.slug }}]({{file.url}} "Taken on {{ file.date | date: "%d %B %Y" }}") * }

    before do
      FileUtils.touch   'images/2008-08-08-alpha-team.jpg'
    end

    it "should have the alt, src, and title" do
      imgs = doc.css('img')
      expect(imgs.size).to eq(1)

      img = imgs.first
      expect(img[:alt]).to eq("alpha-team")
      expect(img[:src]).to eq("/images/2008-08-08-alpha-team.jpg")
      expect(img[:title]).to eq("Taken on 08 August 2008")
    end
  end

end
