// Generated by CoffeeScript 1.6.3
(function() {
  var ExampleView, Tutorial, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Tutorial = window.Tutorial || {};

  Tutorial.ExampleView = ExampleView = (function(_super) {
    __extends(ExampleView, _super);

    function ExampleView() {
      _ref = ExampleView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ExampleView.prototype.initialize = function(_arg) {
      this.initAction = _arg.initAction, this.cleanupAction = _arg.cleanupAction, this.exampleText = _arg.exampleText;
    };

    ExampleView.prototype.init = function() {
      return this.initAction();
    };

    ExampleView.prototype.render = function() {
      return "<p>" + this.exampleText + "</p>";
    };

    ExampleView.prototype.cleanup = function() {
      return this.cleanupAction();
    };

    return ExampleView;

  })(Backbone.View);

}).call(this);
