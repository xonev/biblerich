$ ->
  selector = new BookSelector
    el: $('.book-selector')[0]
    firstOption: "Book highlight"
  selector.on 'go', ({book, chapter}) ->
    if chapter == '0'
      path = "#{book}.html"
    else
      path = "#{book} #{chapter}.html"
    window.location.pathname = selector.slugify(path)
