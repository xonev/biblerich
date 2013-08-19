require 'pathname'
require 'zlib'
require 'stringio'
require 'nokogiri'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage convert_pages_to_html.rb filename"
end.parse!

if ARGV.length != 1
  puts "Incorrect usage"
  exit(1)
end

pn = Pathname.pwd + ARGV[0]
Books = [
  "Genesis",
  "Exodus",
  "Leviticus",
  "Numbers",
  "Deuteronomy",
  "Joshua",
  "Judges",
  "Ruth",
  "1 Samuel",
  "2 Samuel",
  "1 Kings",
  "2 Kings",
  "1 Chronicles",
  "2 Chronicles",
  "Ezra",
  "Nehemiah",
  "Esther",
  "Job",
  "Psalms",
  "Proverbs",
  "Ecclesiastes",
  "Song of Solomon",
  "Isaiah",
  "Jeremiah",
  "Lamentations",
  "Ezekiel",
  "Daniel",
  "Hosea",
  "Joel",
  "Amos",
  "Obadiah",
  "Jonah",
  "Micah",
  "Nahum",
  "Habakkuk",
  "Zephaniah",
  "Haggai",
  "Zechariah",
  "Malachi",
  "Matthew",
  "Mark",
  "Luke",
  "John",
  "Acts",
  "Romans",
  "1 Corinthians",
  "2 Corinthians",
  "Galatians",
  "Ephesians",
  "Philippians",
  "Colossians",
  "1 Thessalonians",
  "2 Thessalonians",
  "1 Timothy",
  "2 Timothy",
  "Titus",
  "Philemon",
  "Hebrews",
  "James",
  "1 Peter",
  "2 Peter",
  "1 John",
  "2 John",
  "3 John",
  "Jude",
  "Revelation"]

Book_name_matcher = Regexp.new("^(#{Books.join("|")})$", true)

def yml_front(title)
  """---
layout: default
title: Bible Rich | #{title}
---"""
end

def xml_to_html(xml, processor)
  doc = Nokogiri::XML.parse(xml)
  doc.search('//sf:span/text()').each do |p|
    element = if Book_name_matcher.match(p.content.strip)
                processor.process_title(p.content)
                'h1'
              else
                'p'
              end
    processor.process_content "\n<#{element}>#{p.content}</#{element}>"
  end
  processor.finish
end

class FileWriter
  def initialize
    @file = nil
  end

  def process_title(title)
    @file.close if @file
    @file = open_file(title)
    @file.write(yml_front(title))
  end

  def process_content(content)
    @file.write(content) if @file
  end

  def finish
    @file.close if @file
  end

  def open_file(title)
    filename = File.join('bible-highlights', title.strip.downcase.gsub(/ /, '-'), 'index.html')
    File.open(filename, 'w')
  end

end

data = pn.read
gz = Zlib::GzipReader.new(StringIO.new(data))
xml_to_html gz.read, FileWriter.new
