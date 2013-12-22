// Generated by CoffeeScript 1.6.3
(function() {
  var BookSelector, CHAPTER_COUNTS, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.BookSelector = BookSelector = (function(_super) {
    __extends(BookSelector, _super);

    function BookSelector() {
      _ref = BookSelector.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    BookSelector.prototype.events = {
      'click button': 'go',
      'change .books': 'updateChapters'
    };

    BookSelector.prototype.initialize = function(_arg) {
      var $optgroup, book, options;
      this.firstOption = _arg.firstOption, this.oldTestament = _arg.oldTestament, this.newTestament = _arg.newTestament;
      this.updateChapters();
      if (this.oldTestament) {
        $optgroup = this.$el.find('.books optgroup[label="Old Testament"]');
        $optgroup.find('option').remove();
        options = [
          (function() {
            var _i, _len, _ref1, _results;
            _ref1 = this.oldTestament;
            _results = [];
            for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
              book = _ref1[_i];
              _results.push("<option>" + book + "</option>");
            }
            return _results;
          }).call(this)
        ];
        $optgroup.append(options.join(''));
      }
      if (this.newTestament) {
        $optgroup = this.$el.find('.books optgroup[label="New Testament"]');
        $optgroup.find('option').remove();
        options = [
          (function() {
            var _i, _len, _ref1, _results;
            _ref1 = this.newTestament;
            _results = [];
            for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
              book = _ref1[_i];
              _results.push("<option>" + book + "</option>");
            }
            return _results;
          }).call(this)
        ];
        return $optgroup.append(options.join(''));
      }
    };

    BookSelector.prototype.slugify = function(str) {
      return str.toLowerCase().replace(/[ ]/g, '-');
    };

    BookSelector.prototype.go = function() {
      return this.trigger('go', {
        book: this.book(),
        chapter: this.chapter()
      });
    };

    BookSelector.prototype.book = function() {
      return this.$el.find('.books option:selected').val().replace(/[^\w\s]+/, '');
    };

    BookSelector.prototype.chapter = function() {
      return this.$el.find('.chapters option:selected').val();
    };

    BookSelector.prototype.updateChapters = function() {
      var buildOption, chapters, options;
      this.$el.find('.chapters').empty();
      switch (this.book()) {
        case 'Genesis':
          options = [["genesis-organization", "Organization"], 1, ["chapter-01-days-of-creation", "1 - Days of Creation"], 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, ["chapter-29-30-twelve-tribes", "29, 30 - Twelve Tribes"], 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50];
          break;
        case 'Exodus':
          options = [20];
          break;
        case 'Daniel':
          options = [["daniel-organization", "Organization"], 1, 2, ["chapter-02-10-kingdoms", "2 - 10 kingdoms"], 3, 4, 5, 6, 7, 8, ["greek-generals", "Greek Generals"], 9, 10, 11, 12];
          break;
        default:
          options = [];
      }
      buildOption = function(chapter) {
        if (typeof chapter === 'number') {
          return "<option value='chapter-" + (sprintf('%02d', chapter)) + "'>" + chapter + "</option>";
        } else {
          return "<option value='" + chapter[0] + "'>" + chapter[1] + "</option>";
        }
      };
      chapters = _.map(options, buildOption);
      if (this.firstOption) {
        chapters = "        <optgroup label='Book'><option value='0'>" + this.firstOption + "</option></optgroup>        <optgroup label='Chapters'>" + chapters + "</optgroup>";
      }
      return this.$el.find('.chapters').append(chapters);
    };

    return BookSelector;

  })(Backbone.View);

  CHAPTER_COUNTS = {
    "Genesis": 50,
    "Exodus": 40,
    "Leviticus": 27,
    "Numbers": 36,
    "Deuteronomy": 34,
    "Joshua": 24,
    "Judges": 21,
    "Ruth": 4,
    "1 Samuel": 31,
    "2 Samuel": 24,
    "1 Kings": 22,
    "2 Kings": 25,
    "1 Chronicles": 29,
    "2 Chronicles": 36,
    "Ezra": 10,
    "Nehemiah": 13,
    "Esther": 10,
    "Job": 42,
    "Psalms": 150,
    "Proverbs": 31,
    "Ecclesiastes": 12,
    "Song of Solomon": 8,
    "Isaiah": 66,
    "Jeremiah": 52,
    "Lamentations": 5,
    "Ezekiel": 48,
    "Daniel": 12,
    "Hosea": 14,
    "Joel": 3,
    "Amos": 9,
    "Obadiah": 1,
    "Jonah": 4,
    "Micah": 7,
    "Nahum": 3,
    "Habakkuk": 3,
    "Zephaniah": 3,
    "Haggai": 2,
    "Zechariah": 14,
    "Malachi": 4,
    "Matthew": 28,
    "Mark": 16,
    "Luke": 24,
    "John": 21,
    "Acts": 28,
    "Romans": 16,
    "1 Corinthians": 16,
    "2 Corinthians": 13,
    "Galatians": 6,
    "Ephesians": 6,
    "Philippians": 4,
    "Colossians": 4,
    "1 Thessalonians": 5,
    "2 Thessalonians": 3,
    "1 Timothy": 6,
    "2 Timothy": 4,
    "Titus": 3,
    "Philemon": 1,
    "Hebrews": 13,
    "James": 5,
    "1 Peter": 5,
    "2 Peter": 3,
    "1 John": 5,
    "2 John": 1,
    "3 John": 1,
    "Jude": 1,
    "Revelation": 22
  };

}).call(this);
