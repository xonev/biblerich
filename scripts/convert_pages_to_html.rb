require 'pathname'
require 'zlib'
require 'stringio'
require 'nokogiri'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage convert_pages_to_html.rb filename"
end.parse!

if ARGV.length != 2
  puts "Incorrect usage"
  exit(1)
end

pn = Pathname.pwd + ARGV[0]
title = ARGV[1]

def yml_front(title)
  puts """---
layout: default
title: Bible Rich | #{title}
---"""
end

def xml_to_html(xml)
  doc = Nokogiri::XML.parse(xml)
  first_line = true
  doc.search('//sf:p/text()').each do |p|
    element = first_line ? 'h1' : 'p'
    yield "<#{element}>#{p.content}</#{element}>"
    first_line = false
  end
end

data = pn.read
gz = Zlib::GzipReader.new(StringIO.new(data))
puts yml_front title
xml_to_html gz.read, &method(:puts).to_proc
