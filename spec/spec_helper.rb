require 'nokogiri'

Dir["./spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
	config.add_formatter(:documentation)
	config.add_formatter(:html, "test-reports/rspec.html")
	config.color_enabled = true
	config.tty = true
end