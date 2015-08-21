define ->

  # ==================================================
  # private stateless variables
  # ==================================================
  # what do you expect
  CONST =
    rafVendors: ['ms', 'moz', 'o']
    msPerFrame: 15 # 1000ms / 16fps
  # raf setup
  rafMethod = undefined
  cafMethod = undefined
  # init
  do ->
    rafMethod = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.msRequestAnimationFrame
    cafMethod = window.cancelAnimationFrame || window.mozCancelAnimationFrame;
    if !rafMethod?
      rafMethod = (cb)->
        setTimeout cb, CONST.msPerFrame
      cafMethod = (req)->
        clearTimeout req

  # create a status obj
  getStatusObject = ->
    iteration = 0
    duration = 0
    startTime = Date.now()
    running = true
    ping = ->
      iteration++
      duration = Date.now() - startTime
    end = ->
      running = false
    getIteration = ->
      iteration
    getDuration = ->
      duration
    getStartTime = ->
      startTime
    isRunning = ->
      running
    exposedObj:
      getIteration: getIteration
      getDuration: getDuration
      getStartTime: getStartTime
      isRunning: isRunning
    internalObj:
      ping: ping
      end: end


  # ==================================================
  # public methods
  # ==================================================
  # setup a request animation frame that stop when the provided method evaluates to false
  # @param function fn; function executed on every step, provided argument is the status object
  # @param function condition; that stops execution when eveluating to false
  # @param function cb; callback executed on end of lo
  # @return the de-registration method
  setConditionalRaf = (fn, condition, cb=()->)->
    req = undefined
    statusObj = getStatusObject()
    method = ->
    method = ->
      statusObj.internalObj.ping()
      if condition( statusObj.exposedObj )
        fn statusObj.exposedObj
        req = rafMethod method
      else
        statusObj.internalObj.end()
        fn statusObj.exposedObj
        cb statusObj.exposedObj
    req = rafMethod method
    ()->
      statusObj.internalObj.end()
      cb statusObj.exposedObj
      cafMethod req

  # setup a request animation frame that stop after the provided duration
  # ATTENTION: there is no guarantee that it ends on the provided time, could be after the provided time
  # @param function fn; function executed on every step, provided argument is the status object
  # @param int duration; nr of milliseconds after which to stop
  # @return the de-registration method
  setElapsedRaf = (fn, duration, cb=undefined)->
    condition = (status)->
      if status.getDuration() >= duration then false else true
    setConditionalRaf fn, condition, cb

  # setup a request animation frame that stop after the provided iterations
  # @param function fn; function executed on every step, provided argument is the status object
  # @param int intervals; nr of milliseconds after which to stop
  # @return the de-registration method
  setIntervalRaf = (fn, intervals, cb=undefined)->
    condition = (status)->
      if status.getIteration() >= intervals then false else true
    setConditionalRaf fn, condition, cb


  setConditionalRaf: setConditionalRaf
  setElapsedRaf: setElapsedRaf
  setIntervalRaf: setIntervalRaf