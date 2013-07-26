require 'pathname'
require 'zlib'
require 'stringio'
require 'nokogiri'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage convert_pages_to_html.rb filename"
end.parse!
pn = Pathname.pwd + ARGV[0]

data = pn.read
gz = Zlib::GzipReader.new(StringIO.new(data))
xml = gz.read
doc = Nokogiri::XML.parse(xml)
first_line = true
doc.search('//sf:p/text()').each do |p|
  element = first_line ? 'h1' : 'p'
  puts "<#{element}>#{p.content}</#{element}>"
  first_line = false
end
