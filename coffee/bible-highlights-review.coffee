$ ->
  selector = new BookSelector
    el: $('.book-selector')[0]
    firstOption: "Book highlight"
  selector.on 'go', ({book, chapter}) ->
    if chapter == '0'
      path = "#{book} flashcards.html"
    else
      path = "#{book} #{chapter} flashcards.html"
    window.location.pathname = selector.slugify(path)
