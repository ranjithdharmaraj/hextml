require 'nokogiri'
require 'pathname'
require 'logger'

class Hextml

  def initialize(args={})
    @taxo_file  = generate_xml_path(args[:taxo_xml] || 'taxonomy.xml')
    @dest_file  = generate_xml_path(args[:dest_xml] || 'destinations.xml')
    @html_file  = generate_html_path(args[:example_html] || 'example.html')

    @logger   ||= Logger.new(Pathname.new('log').join('hextml.log'))

    @logger.info "Input Files: #{@taxo_file}, #{@dest_file}"
  end

  def prepare_data
    @taxo_xml     = parse_xml(@taxo_file)
    @example_html = parse_html(@html_file)
    #@dest_xml = parse_xml(@dest_file)
    dest_content  = false
    html_str      = []

    parse_as_reader(@dest_file).each do |node|
      @logger.info "Node name: #{node.name}"

      if dest_content
        html_str << "<h5>#{node.name}</h5>"
        html_str << "<p>#{node.inner_xml}</p>"
      end

      if node.name == 'destination'
        dest_content ? true : false
        #Create html if html_str is not empty
        unless html_str.empty?

        end
      end
    end
  end

protected

  def generate_xml_path(filename='')
    path = Pathname.new('tmp').join('source_xml',filename)
    @logger.error "XML File does not exist" unless path.exist?
    path
  end

  def generate_html_path(filename='')
    path = Pathname.new('tmp').join(filename)
    @logger.error "HTML example file does not exist" unless path.exist?
    path
  end

  def create_html(filename,content)
    doc = Nokogiri::HTML(File.open(generate_html_path(filename)))
    doc.create_cdata(content)
  end

  def parse_html(file_name)
    Nokogiri::XML(File.open(file_path))
  end

  def parse_xml(file_path)
    Nokogiri::XML(File.open(file_path))
  end

  def parse_as_reader(file_path)
    Nokogiri::XML::Reader(File.open(file_path))
  end


end # Hextml