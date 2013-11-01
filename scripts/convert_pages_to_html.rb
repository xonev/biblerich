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
Sections = [
  "Genesis Organization",
  "Genesis 1 - Days"
]
(1..50).to_a.each { |num| Sections.push "Genesis #{num}" }

Matcher = Regexp.new("^(#{Sections.join("|")})$", true)

def log(message)
  puts message
end

def slugify(str)
  title = str.strip.downcase.gsub(/ /, '-')
  match = title.match /(\d+)((-+[\w]+)*)/
  if match
    # should be something like chapter-02-rest-of-title
    title = sprintf "%s-%02d%s", "chapter", match[1], match[2]
  end
  title
end

def yml_front(title, path_root)
  """---
layout: default
title: Bible Rich | #{title}
image_path: /img/bible-highlights/#{path_root}/#{slugify(title)}.png
image_alt: #{title}
audio_mp3_path: /audio/bible-highlights/#{path_root}/#{slugify(title)}.mp3
audio_wav_path: /audio/bible-highlights/#{path_root}/#{slugify(title)}.wav
---\n"""
end

def xml_to_html(xml, processor)
  @matched ||= []
  doc = Nokogiri::XML.parse(xml)
  doc.search('//sf:p/text() | //sf:span/text()').each do |p|
    if Matcher.match(p.content.strip) && !Regexp.new("^(#{@matched.join("|")})$", true).match(p.content.strip)
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

  def initialize(has_subtitles = false, path_root)
    @file = nil
    @state = States::Start
    @coder = HTMLEntities.new
    @has_subtitles = has_subtitles
    @path_root = path_root
    log("In state: Start")
  end

  def process_title(title)
    title = title.strip
    log("Processing title: #{title}")
    output_footer
    @file.close if @file
    @file = open_file(title)
    @file.write(yml_front(title, @path_root))
    @title = title
    if @has_subtitles
      @state = States::MidTitle
      log("In state: MidTitle")
    else
      output_title @title
      output_header
      output_media
      @state = States::Content
      log("In state: Content")
    end
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
    title = slugify(title)
    filename = File.join('bible-highlights', @path_root, "#{title}.html")
    log("Opening file: #{filename}")
    File.open(filename, 'w')
  end

end

data = pn.read
gz = Zlib::GzipReader.new(StringIO.new(data))
xml_to_html gz.read, FileWriter.new(false, "genesis")
