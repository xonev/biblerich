fitH1 = -> $('.content h1').quickfit
    max: 38.5
    min: 16
    truncate: true
    tolerance: 0.05

$ ->
  fitH1()
  window.onresize = fitH1
