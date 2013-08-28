$ ->
  selector = new BookSelector
    el: $('.book-selector')[0]
    oldTestament: ['Genesis', 'Exodus']
    newTestament: []
  selector.on 'go', ({book, chapter}) ->
    if chapter == '0'
      path = "#{book} flashcards.html"
    else
      path = "/bible-highlights/review/#{book}/chapter #{chapter}.html"
    window.location.pathname = selector.slugify(path)
