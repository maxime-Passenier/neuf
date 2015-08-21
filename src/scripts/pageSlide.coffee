# tha config
requirejs.config
  paths:
    underscore: "underscore-min"

# start the app
require ['lib/pageSlide'], (pageSlide)->

  parentNode = document.querySelector('#thaPageSlider')
  childWrapNode = document.querySelector('#thaPageSliderWrap')

  slider = pageSlide.slider parentNode, childWrapNode
