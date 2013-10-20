fs = require('fs')
util = require 'util'
glob = require('glob')
files = glob.sync '/Users/soxley/Downloads/gen*.png'
console.log util.inspect(files)

getChapterNumber = (file) ->
  match = file.match /\d(\d\d)/
  if match
    match[1]
  else
    match

isChapter = (file) ->
  if file.match /\d\d\d-s[.]png$/
    true
  else
    false

getChapterDetail = (file) ->
  match = file.match /\d\d\d[-_](.*)[.]png$/
  if match
    match[1]
  else
    match

for file in files
  newPath = ''
  chapNum = getChapterNumber file
  if isChapter file
    newPath = "./img/bible-highlights/genesis/chapter-#{chapNum}.png"
  else
    chapDetail = getChapterDetail file
    newPath = "./img/bible-highlights/genesis/chapter-#{chapNum}-#{chapDetail}.png"
  fs.renameSync(file, newPath)
