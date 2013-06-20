// Generated by CoffeeScript 1.6.2
(function() {
  $(function() {
    var selector;

    selector = new BookSelector({
      el: $('.book-selector')[0]
    });
    return selector.on('go', function(_arg) {
      var book, chapter;

      book = _arg.book, chapter = _arg.chapter;
      return window.location.pathname = selector.slugify("" + book + " " + chapter + " flashcards.html");
    });
  });

}).call(this);
