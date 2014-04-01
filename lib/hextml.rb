class Hextml
  attr_accessor :prev_node, :hier_hash, :child_str

  def initialize(args={})
    @taxo_file  = generate_xml_path(args[:taxo_xml])
    @dest_file  = generate_xml_path(args[:dest_xml])
    @html_file  = generate_html_path(args[:example_html])
    @html_str   = []
    @logger   ||= Logger.new(Pathname.new('log').join('hextml.log'))

    @logger.info "Input Files: #{@taxo_file}, #{@dest_file}"
  end

  def prepare_batch
    @example_html = parse_html(@html_file)
    read_content  = false
    parse_as_reader(@dest_file).each do |node|

      dest_title = node.attribute('title')
      atlas_id   = node.attribute('atlas_id')
      if read_content 
        @html_str << prepare_subtitle(node.name) if node.name != '#text' && node.name != '#cdata-section' && node.name != @prev_node
        @html_str << "<p>#{node.value}</p>"
      end

      if node.name == 'destination'
        read_content = content_status(read_content)
        @html_str = prepare_destination_html(dest_title,atlas_id) if @html_str.any?
      end
    end
  end

  def prepare_hierarchy(atlas_id)
    doc = parse_xml(@taxo_file)
    child_str = []
    elems = doc.search "node[atlas_node_id='#{atlas_id}']"
    elems.each do |node|
      parent_node_id = "#{node.attribute('atlas_node_id')}"  
      node.children.each do |child|
        if child.name == "node" || child.name == "node_name"
          child.content.split("\n").each do | child_row |
            child_str << child_row unless child_row.empty?
          end
        end
      end
    end
    #puts "Hier: #{child_str.inspect}"
    hierarchy_list(child_str)
  end

  def prepare_destination_html(dest_title,atlas_id)
    doc = parse_html(@html_file)
    puts "Atlas ID: #{atlas_id}"
    hierarchy_items = prepare_hierarchy(atlas_id)

    doc.at_css("div#container h1").inner_html = "Lonely Planet: #{dest_title}"
    doc.at_css("div#main div.secondary-navigation li a").inner_html = dest_title
    doc.at_css("div#wrapper div.inner").inner_html = hierarchy_items
    doc.at_css("div#main div.inner").inner_html = @html_str.join("")

    File.open(generate_html_path("#{dest_title}.html","output"),"w") do |new_file|
      new_file.write "#{doc}"
    end 
    
    return []
  end
  

protected
  
  def prepare_subtitle(subtitle)
    @prev_node = subtitle
    subtitle = subtitle.capitalize
    subtitle = subtitle.gsub(/\_/," ")
    "<h4>#{subtitle}</h4>"
  end

  def hierarchy_list(child_str)
    return_str = '<ul>'
    child_str.each do |el|
      return_str << "<li><a href='#{el}.html'>#{el}</a></li>"
    end
    return_str << '</ul>'
    #hierarchy_items =  "<ul>"
    #hierarchy_items = hier_hash.each(&method(:hash_to_html))
    #hierarchy_items = "</ul>
  end

  def content_status(state)
    state ? false : true
  end

  def generate_xml_path(filename='')
    path = Pathname.new('tmp').join('source_xml',filename)
    @logger.error "XML File [ #{filename} ] does not exist" unless path.exist?
    path
  end

  def generate_html_path(filename='',dir='tmp')
    path = Pathname.new(dir).join(filename)
    @logger.error "HTML example file [ #{filename} ] does not exist" unless path.exist?
    path
  end

  def parse_html(file_path)
    Nokogiri::HTML.parse(File.open(file_path))
  end

  def parse_xml(file_path)
    Nokogiri::XML(File.open(file_path))
  end

  def parse_as_reader(file_path)
    Nokogiri::XML::Reader(File.open(file_path))
  end

  def hash_to_html_list(key,value)
     if value.nil?
       puts "<li>#{key}</li>"
     elsif value.is_a?(Hash)
       puts "<li>#{key}"
       puts "<ul>"
       value.each(&method(:hash_to_html))
       puts "</ul></li>"
     else
       fail "Failed with a #{value.class}"
     end
  end
end # Hextml