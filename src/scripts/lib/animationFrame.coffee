define ->

  # get an animation frame thingy
  # @param function callbackArg the iteration object
  get = (callbackArg)->
    if typeof callbackArg != 'function'
      throw new Exception('Provide a callback function')
    active = false
    callback = callbackArg
    animationId = undefined
    requestAnimationFrame = undefined
    cancelAnimationFrame = undefined
    vendors = ['ms', 'moz', 'o']

    # setup animation functions
    setupAnimation = ->
      for vendor in vendors
        if window[ vendor + 'RequestAnimationFrame']?
          requestAnimationFrame = window[ vendor + 'RequestAnimationFrame']
          cancelAnimationFrame = window[ vendor + 'CancelAnimationFrame'] || window[ vendor + 'CancelRequestAnimationFrame']
      if !requestAnimationFrame? or !cancelAnimationFrame?
        requestAnimationFrame = (callback, element)->
          currTime = new Date().getTime();
          timeToCall = Math.max(0, 16 - (currTime - lastTime));
          id = window.setTimeout ->
            callback currTime + timeToCall
          , timeToCall
          lastTime = currTime + timeToCall
          id
        cancelAnimationFrame = (id)->
          clearTimeout(id)

    # execute a animation
    execute = ->
      return if !active
      animationId = requestAnimationFrame execute
      callback( animationId )

    # public: start the animation iteration
    start = ->
      active = true
      execute()

    # public stop animation iteration
    stop = ->
      active = false
      if animationId?
        cancelAnimationFrame animationId
      animationId = undefined

    # init
    setupAnimation()

    # public api
    start: start
    stop: stop

  get: get