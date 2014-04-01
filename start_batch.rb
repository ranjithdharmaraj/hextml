require 'nokogiri'
require 'pathname'
require 'logger'
require 'active_support/core_ext/hash/conversions'

require_relative "lib/hextml.rb"

params = {
	taxo_xml: 'taxonomy.xml',
	dest_xml: 'destinations.xml',
	example_html: 'example.html'
}

puts "Starting....."
hextml = Hextml.new(params)

hextml.prepare_batch
puts "Completed....."