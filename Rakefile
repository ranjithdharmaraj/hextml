require 'nokogiri'
require 'pathname'
require 'logger'

require_relative "lib/hextml.rb"

task :process_xml do
	params = {
		taxo_xml: 'taxonomy.xml',
		dest_xml: 'destinations.xml',
		example_html: 'example.html',
		output_dir: 'output'
	}
	puts "Starting..."
	hextml = Hextml.new(params)
	hextml.prepare_batch
	puts "Completed..."
end

task :default => :process_xml