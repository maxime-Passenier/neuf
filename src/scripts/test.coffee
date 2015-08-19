# tha config
requirejs.config
  paths:
    underscore: "underscore-min"

# start the app
require [], ->

  timerNow = if window.self.performance?.now? then ()-> window.self.performance.now() else ()-> Date.now()

  digestSpoofed = false
  rootScope = undefined

  spoofDigest = ->
    return if digestSpoofed
    digestSpoofed = true
    getRootScope()
    scopePrototype = Object.getPrototypeOf(rootScope);
    oldDigest = scopePrototype.$digest;
    scopePrototype.$digest = ()->
      start = timerNow();
      oldDigest.apply(this, arguments);
      diff = (timerNow() - start);
      console.log diff

  getRootScope = ->
    return rootScope if rootScope?
    scopeEl = document.querySelector('.ng-scope');
    return if !scopeEl?
    rootScope = angular.element(scopeEl).scope().$root


  testA = ->
    console.log timerNow()
    testB( 'a', 'b')

  testB = ->
    console.log timerNow()
    console.log 'arguments.callee.caller', arguments.callee.caller
    console.log 'arguments.callee.name', arguments.callee.name
    console.log 'arguments.callee.arguments', arguments.callee.arguments

#  setTimeout(testA, 1000)
  console.log timerNow()
  setTimeout ->
    console.log timerNow()
  , 5000
