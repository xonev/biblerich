$ ->
  selector = new BookSelector el: $('.book-selector')[0]
  selector.on 'go', ({book, chapter}) ->
    window.location.pathname = selector.slugify("#{book} #{chapter}.html")
