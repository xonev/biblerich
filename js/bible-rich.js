// Generated by CoffeeScript 1.6.3
(function() {
  var fitH1;

  fitH1 = function() {
    return $('.content h1').quickfit({
      max: 38.5,
      min: 16,
      truncate: true,
      tolerance: 0.05
    });
  };

  $(function() {
    fitH1();
    return window.onresize = fitH1;
  });

}).call(this);