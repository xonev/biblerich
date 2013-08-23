# get all of the directories in the directory
dirs = Dir.entries(Dir.getwd)
dirs.each do |dirname|
  unless /^[.]/.match dirname
    # get all of the files in the directory
    files = Dir.entries(dirname)
    files.each do |filename|
      unless /^[.]/.match filename
        old_name = File.join(dirname, filename)
        new_name = File.join(dirname, "book-simple#{File.extname(filename)}")
        puts "#{old_name} -> #{new_name}"
        File.rename(old_name, new_name)
      end
    end
  end
end
