require 'spec_helper'
require 'pathname'

describe Hextml do
  subject (:hextml_obj) { Hextml.new }

  it "should be a valid object" do
    expect(hextml_obj).to be_a Object
  end

  it "should have a method to prepare data" do
    should respond_to :prepare_data
  end
end

describe "Batch processing" do
  context 'as a HTML-XML engine' do
    it 'should find input xml files' do
      path = Pathname.new('tmp').join('source_xml','taxonomy.xml') 
      expect(File).to exist(path)

      path = Pathname.new('tmp').join('source_xml','destinations.xml') 
      expect(File).to exist(path)
    end

    it 'should find sample html file' do
      path = Pathname.new('tmp').join('example.html') 
      expect(File).to exist(path)
    end

    it 'should find atleast one valid node in the xml' do
      path = Pathname.new('tmp').join('source_xml','taxonomy.xml')
      xml = Nokogiri::XML(File.open(path))
      xml.search('//taxonomies').count.should be >= 1
    end  
  end
end