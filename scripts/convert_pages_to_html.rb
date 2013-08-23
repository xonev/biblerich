require 'pathname'
require 'zlib'
require 'stringio'
require 'nokogiri'
require 'optparse'
require 'active_support/core_ext/string'
require 'htmlentities'

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
  #"Genesis",
  #"Exodus",
  #"Leviticus",
  #"Numbers",
  #"Deuteronomy",
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

def log(message)
  puts message
end

def slugify(str)
  str.strip.downcase.gsub(/ /, '-')
end

def yml_front(title)
  """---
layout: default
title: Bible Rich | #{title}
image_path: /img/bible-highlights/books/#{slugify(title)}.png
image_alt: #{title}
audio_mp3_path: /audio/bible-highlights/#{slugify(title)}/book-simple.mp3
audio_wav_path: /audio/bible-highlights/#{slugify(title)}/book-simple.wav
---\n"""
end

def xml_to_html(xml, processor)
  @matched ||= []
  doc = Nokogiri::XML.parse(xml)
  doc.search('//sf:span/text()').each do |p|
    if Book_name_matcher.match(p.content.strip) && !Regexp.new("^(#{@matched.join("|")})$", true).match(p.content.strip)
      processor.process_title(p.content)
      @matched.push(p.content.strip)
    else
      processor.process_content(p.content)
    end
  end
  processor.finish
end

class FileWriter
  module States
    Start = 0
    MidTitle = 1
    SubTitle = 2
    Content = 3
  end

  def initialize
    @file = nil
    @state = States::Start
    @coder = HTMLEntities.new
    log("In state: Start")
  end

  def process_title(title)
    title = title.strip
    log("Processing title: #{title}")
    output_footer
    @file.close if @file
    @file = open_file(title)
    @file.write(yml_front(title))
    @book = title
    @title = title
    @state = States::MidTitle
    log("In state: MidTitle")
  end

  def process_content(content)
    content = content.strip
    log("Processing content: #{content}")
    case @state
    when States::MidTitle
      @title = "#{@title} #{content}"
      log("Added to title: #{@title}")
      if content == '-'
        @state = States::SubTitle
        log("In state: SubTitle")
      end
    when States::SubTitle
      if /^-/.match content
        output_title(@title)
        output_header
        output_media
        output_content(content[1, content.length-1])
        @state = States::Content
        log("In state: Content")
      else
        @title = "#{@title} #{content.titleize}"
        log("Added to title: #{@title}")
      end
    when States::Content
      output_content(content)
    end
  end

  def output_title(title)
    log("Outputting title: #{title}")
    output("<h1>#{@coder.encode(title)}</h1>\n")
  end

  def output_media
    log("Outputting media")
    output("{% include media.html %}")
  end

  def output_header
    output("{% include picture-page-header.html %}")
  end

  def output_footer
    output("{% include picture-page-footer.html %}")
  end

  def output_content(content)
    log("Outputting content: #{content}")
    output("<p>#{@coder.encode(content)}</p>")
  end

  def output(text)
    @file.write("#{text}\n") if @file
  end

  def finish
    log("Finished")
    @file.close if @file
  end

  def open_file(title)
    filename = File.join('bible-highlights', slugify(title), 'index.html')
    log("Opening file: #{filename}")
    File.open(filename, 'w')
  end

end

data = pn.read
gz = Zlib::GzipReader.new(StringIO.new(data))
xml_to_html gz.read, FileWriter.new
