window.BookSelector = class BookSelector extends Backbone.View
  events:
    'click button': 'go'
    'change .books': 'updateChapters'

  initialize: ({@firstOption, @oldTestament, @newTestament}) ->
    @updateChapters()
    if @oldTestament
      $optgroup = @$el.find('.books optgroup[label="Old Testament"]')
      $optgroup.find('option').remove()
      options = ["<option>#{book}</option>" for book in @oldTestament]
      $optgroup.append(options.join(''))
    if @newTestament
      $optgroup = @$el.find('.books optgroup[label="New Testament"]')
      $optgroup.find('option').remove()
      options = ["<option>#{book}</option>" for book in @newTestament]
      $optgroup.append(options.join(''))

  slugify: (str) ->
    str.toLowerCase().replace(/[ ]/g, '-')

  go: ->
    @trigger 'go',
      book: @book()
      chapter: @chapter()

  book: ->
    @$el.find('.books option:selected').val().replace(/[^\w\s]+/, '')

  chapter: ->
    @$el.find('.chapters option:selected').val()

  updateChapters: ->
    @$el.find('.chapters').empty()
    # Eventually (and theoretically) we'll have something for all of the chapters.
    # Until that day, we'll add them as they're available.
    # options = ("<option>#{num}</option>" for num in [1..CHAPTER_COUNTS[@book()]])
    switch @book()
      when 'Genesis'
        options = [
          ["genesis-organization", "organization"],
          1,
          ["chapter-01-days-of-creation", "1 - days of creation"],
          2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
          ["chapter-29-30-twelve-tribes", "29, 30 - twelve tribes"],
          31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50
        ]
      when 'Exodus' then options = [20]
      when 'Daniel'
        options = [
          ["daniel-organization", "organization"],
          1, 2,
          ["chapter-02-10-kingdoms", "2 - 10 kingdoms"],
          3
        ]
      else options = []
    buildOption = (chapter) ->
      if typeof chapter == 'number'
        "<option value='chapter-#{sprintf '%02d', chapter}'>#{chapter}</option>"
      else
        "<option value='#{chapter[0]}'>#{chapter[1]}</option>"
    chapters = _.map options, buildOption
    # Sometimes we'll want an arbitrary "first option"
    if @firstOption
      chapters = "
        <optgroup label='Book'><option value='0'>#{@firstOption}</option></optgroup>
        <optgroup label='Chapters'>#{chapters}</optgroup>"
    @$el.find('.chapters').append(chapters)

CHAPTER_COUNTS =
  "Genesis": 50
  "Exodus": 40
  "Leviticus": 27
  "Numbers": 36
  "Deuteronomy": 34
  "Joshua": 24
  "Judges": 21
  "Ruth": 4
  "1 Samuel": 31
  "2 Samuel": 24
  "1 Kings": 22
  "2 Kings": 25
  "1 Chronicles": 29
  "2 Chronicles": 36
  "Ezra": 10
  "Nehemiah": 13
  "Esther": 10
  "Job": 42
  "Psalms": 150
  "Proverbs": 31
  "Ecclesiastes": 12
  "Song of Solomon": 8
  "Isaiah": 66
  "Jeremiah": 52
  "Lamentations": 5
  "Ezekiel": 48
  "Daniel": 12
  "Hosea": 14
  "Joel": 3
  "Amos": 9
  "Obadiah": 1
  "Jonah": 4
  "Micah": 7
  "Nahum": 3
  "Habakkuk": 3
  "Zephaniah": 3
  "Haggai": 2
  "Zechariah": 14
  "Malachi": 4
  "Matthew": 28
  "Mark": 16
  "Luke": 24
  "John": 21
  "Acts": 28
  "Romans": 16
  "1 Corinthians": 16
  "2 Corinthians": 13
  "Galatians": 6
  "Ephesians": 6
  "Philippians": 4
  "Colossians": 4
  "1 Thessalonians": 5
  "2 Thessalonians": 3
  "1 Timothy": 6
  "2 Timothy": 4
  "Titus": 3
  "Philemon": 1
  "Hebrews": 13
  "James": 5
  "1 Peter": 5
  "2 Peter": 3
  "1 John": 5
  "2 John": 1
  "3 John": 1
  "Jude": 1
  "Revelation": 22

