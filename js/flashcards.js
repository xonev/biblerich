// Generated by CoffeeScript 1.6.3
(function() {
  var CardView, Flashcards, NavigationView, Router, _ref, _ref1, _ref2,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.Flashcards = Flashcards = {
    init: function(pageUrl, options, cardData) {
      var router;
      if (options == null) {
        options = {};
      }
      if (cardData == null) {
        cardData = null;
      }
      if (_.isArray(options)) {
        cardData = options;
        options = {};
      }
      router = new Flashcards.Router({
        cardData: cardData,
        cardOptions: options
      });
      Backbone.history.start({
        root: pageUrl
      });
      return router.start();
    }
  };

  Flashcards.Router = Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      _ref = Router.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Router.prototype.routes = {
      "card/:id": "showCard"
    };

    Router.prototype.initialize = function(_arg) {
      var cardData, cardOptions, _i, _ref1, _results,
        _this = this;
      cardData = _arg.cardData, cardOptions = _arg.cardOptions;
      this.numCards = cardData.length;
      this.ids = (function() {
        _results = [];
        for (var _i = 1, _ref1 = this.numCards; 1 <= _ref1 ? _i <= _ref1 : _i >= _ref1; 1 <= _ref1 ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      this.navigationView = new NavigationView({
        cardData: cardData,
        imageFirst: !!cardOptions.imageFirst,
        el: document.getElementById('flashcards')
      });
      this.navigationView.on('previous', function() {
        return _this.changeRoute(-1);
      });
      this.navigationView.on('next', function() {
        return _this.changeRoute(1);
      });
      return this.navigationView.on('shuffle', function() {
        return _this.ids = _.shuffle(_this.ids);
      });
    };

    Router.prototype.showCard = function(id) {
      this.index = _.indexOf(this.ids, parseInt(id));
      return this.navigationView.show(this.ids[this.index] - 1);
    };

    Router.prototype.changeRoute = function(amount) {
      var newIndex;
      newIndex = this.index + amount;
      newIndex = newIndex >= 0 ? newIndex : newIndex % this.numCards + this.numCards;
      this.index = newIndex % this.numCards;
      return this.navigate("card/" + this.ids[this.index], {
        trigger: true
      });
    };

    Router.prototype.start = function() {
      return this.firstCard();
    };

    Router.prototype.firstCard = function() {
      return this.navigate('card/1', {
        trigger: true
      });
    };

    return Router;

  })(Backbone.Router);

  Flashcards.NavigationView = NavigationView = (function(_super) {
    __extends(NavigationView, _super);

    function NavigationView() {
      _ref1 = NavigationView.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    NavigationView.prototype.cardViews = [];

    NavigationView.prototype.events = {
      'click .prev': 'previous',
      'click .next': 'next',
      'click .flip': 'flip',
      'click .shuffle': 'shuffle'
    };

    NavigationView.prototype.initialize = function(_arg) {
      this.cardData = _arg.cardData, this.imageFirst = _arg.imageFirst;
    };

    NavigationView.prototype.previous = function() {
      return this.trigger('previous');
    };

    NavigationView.prototype.next = function() {
      return this.trigger('next');
    };

    NavigationView.prototype.flip = function() {
      var _ref2;
      return (_ref2 = this.view) != null ? _ref2.toggle() : void 0;
    };

    NavigationView.prototype.shuffle = function() {
      return this.trigger('shuffle');
    };

    NavigationView.prototype.show = function(index) {
      var _ref2;
      if ((_ref2 = this.view) != null) {
        _ref2.remove();
      }
      if (this.cardViews[index]) {
        this.view = this.cardViews[index];
      } else if (this.cardData.length > index) {
        this.view = this.cardViews[index] = new CardView(this.cardData[index], this.imageFirst);
      }
      return this.$el.prepend(this.view.render());
    };

    return NavigationView;

  })(Backbone.View);

  Flashcards.CardView = CardView = (function(_super) {
    __extends(CardView, _super);

    function CardView() {
      this.toggle = __bind(this.toggle, this);
      _ref2 = CardView.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    CardView.prototype.className = 'card';

    CardView.prototype.events = {
      'click': 'toggle'
    };

    CardView.prototype.initialize = function(_arg, imageFirst) {
      this.img = _arg.img, this.text = _arg.text;
      this.imageFirst = imageFirst != null ? imageFirst : false;
      this.textElement = $("<p>" + this.text + "</p>");
      this.imgElement = $("<img src='/img/flashcards/" + this.img + "' alt='click to see answer'></img>");
      this.showingImage = this.imageFirst;
      return this.$el.append(this.getNotShown(!this.showingImage));
    };

    CardView.prototype.getNotShown = function(showingImage) {
      if (showingImage) {
        return this.textElement;
      } else {
        return this.imgElement;
      }
    };

    CardView.prototype.getDirection = function(showingImage) {
      if (showingImage) {
        return 'rl';
      } else {
        return 'lr';
      }
    };

    CardView.prototype.toggle = function() {
      this.$el.flip({
        direction: this.getDirection(this.showingImage),
        speed: 200,
        content: this.getNotShown(this.showingImage)[0],
        color: 'white'
      });
      return this.showingImage = !this.showingImage;
    };

    CardView.prototype.render = function() {
      return this.el;
    };

    CardView.prototype.remove = function() {
      return this.$el.detach();
    };

    return CardView;

  })(Backbone.View);

}).call(this);
