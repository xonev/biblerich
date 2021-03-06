// Generated by CoffeeScript 1.6.3
(function() {
  $(function() {
    var selector;
    selector = new BookSelector({
      el: $('.book-selector')[0],
      oldTestament: ['Genesis', 'Exodus'],
      newTestament: []
    });
    return selector.on('go', function(_arg) {
      var book, chapter, path;
      book = _arg.book, chapter = _arg.chapter;
      path = "/bible-highlights/review/" + book + "/" + chapter + ".html";
      return window.location.pathname = selector.slugify(path);
    });
  });

}).call(this);
