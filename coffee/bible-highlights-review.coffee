$ ->
  selector = new BookSelector
    el: $('.book-selector')[0]
    oldTestament: ['Genesis', 'Exodus']
    newTestament: []
  selector.on 'go', ({book, chapter}) ->
    path = "/bible-highlights/review/#{book}/#{chapter}.html"
    window.location.pathname = selector.slugify(path)
