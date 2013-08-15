#!/usr/bin/ruby
require 'RMagick'
require 'pathname'

module ImageConverter
  include Magick

  def self.convert(filename, new_filename)
    imgs = ImageList.new(filename)
    imgs.write(new_filename)
  end
end

def make_absolute_path(path)
  path = Pathname.new(path)
  if !path.absolute?
    path = Pathname.new(Dir.getwd).join path
  end
end

def choose_name(path_key, first, second)
  @file_counts ||= {}
  if @file_counts[path_key]
    @file_counts[path_key] += 1
    file_name = "#{second}.png"
  else
    @file_counts[path_key] = 1
    file_name = "#{first}.png"
  end
  file_name
end

# Extract the input and output directories
if ARGV.length != 2
  puts 'Usage: ruby extract_flashcards.rb input_dir output_dir'
  exit 0
end

crawl_dir = ARGV[0]
output_dir = ARGV[1]

crawl_path = make_absolute_path crawl_dir
output_path = make_absolute_path output_dir

tiff_paths = Dir.glob(File.join(crawl_path.to_s, "**", "*.tiff"))

tiff_paths.each do |path|
  path_key = Pathname.new(path).dirname.to_s
  file_name =
    case path_key
    when /bookhighlights(\d)_(\d)(\w+)#/
      folder_name = 'books'
      # Choose the first or second name, depending on whether it's the first or
      # second image from this doc
      file_name = choose_name path_key, "#{$1}#{$3}", "#{$2}#{$3}"
      File.join(folder_name, file_name)
    when /bookhighlights(\d?\w+)_(\d?\w+)#/
      folder_name = 'books'
      file_name = choose_name path_key, $1, $2
      File.join(folder_name, file_name)
    when /commandment(\d+)_(\d+)#/
      folder_name = 'commandments'
      file_name = choose_name path_key, $1, $2
      File.join(folder_name, file_name)
    when /day(\d+)_(\d+)#/
      folder_name = 'days-of-creation'
      file_name = choose_name path_key, $1, $2
      File.join(folder_name, file_name)
    end
  new_filename = output_path + file_name
  ImageConverter.convert(path, new_filename)
end
