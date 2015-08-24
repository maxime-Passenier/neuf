define ['lib/raf'], (raf)->

  # ==================================================
  # private stateless
  # ==================================================
  CONST =
    # the nr of milliseconds to reposition the pages
    reposDuration: 200

  # calculate the dimesnions for the given node
  getDimensions = (node)->
    node.getBoundingClientRect()

  # register an event, returns a deregister fn
  registerEvent = (node, event, method)->
    node.addEventListener event, method
    ->
      node.removeEventListener event, method

  # ==================================================
  # the slider
  # ==================================================
  slider = (parentNode, childWrapNode)->

    # ------------------------------
    # properties
    # ------------------------------
    # all the nodes and their info
    nodes = undefined
    # info regarding the current drag
    drag = undefined
    # the auto position interval de-registration method
    autoPosInterval = undefined
    # info regarding the positioning
    position =
      current: 0
      nrOfPages: undefined

    # ------------------------------
    # internal methods
    # ------------------------------
    # calculate the elements positioning
    calcPos = ->
      nodes.parent.dim = getDimensions nodes.parent.node
      nodes.wrap.dim = getDimensions nodes.wrap.node
      position.nrOfPages = Math.ceil(nodes.wrap.dim.width / nodes.parent.dim.width)

    # register the events
    registerEvents = ->
      nodes.parent.events.mousedown = registerEvent nodes.parent.node, 'mousedown', startDrag

    # when dragging starts
    startDrag = (event)->
      stopAnimateToPos()
      nodes.parent.events.mousemove = registerEvent document, 'mousemove', dragging
      nodes.parent.events.mouseup = registerEvent document, 'mouseup', stopDrag
      drag =
        initialX: event.pageX
        initialPos: position.current
        currentPos: position.current
        mousePos: event.pageX
        ts: Date.now()
        speed: undefined

    # when dragging starts
    stopDrag = ->
      move drag.currentPos
      autoPosition drag.currentPos
      drag = undefined
      nodes.parent.events.mousemove?()
      nodes.parent.events.mousemove = undefined
      nodes.parent.events.mouseup?()
      nodes.parent.events.mouseup = undefined

    # reposition the wrap to the appropriate page
    autoPosition = (pos)->
      currentPage = Math.round( pos / nodes.parent.dim.width)
      goToPos = currentPage * nodes.parent.dim.width
      if goToPos >= 0
        goToPos = 0
      else if currentPage < ((Math.ceil(nodes.wrap.dim.width / nodes.parent.dim.width) - 1)*-1)
        goToPos = nodes.parent.dim.width * ((Math.ceil(nodes.wrap.dim.width / nodes.parent.dim.width) - 1)*-1)
      animateToPos goToPos

    # start postioning animation
    animateToPos = (pos)->
      stopAnimateToPos()
      distance = position.current - pos
      distPerMs = distance / CONST.reposDuration
      initPos = position.current
      autoPosInterval = raf.setElapsedRaf (status)->
        if status.isRunning()
          stepSize = distPerMs * status.getDuration()
          move(  initPos - stepSize )
        else
          move( pos )
      , CONST.reposDuration

    # stop the positioning animation
    stopAnimateToPos = ->
      if autoPosInterval?
        autoPosInterval()
        autoPosInterval = undefined

    # when we are dragging the bugger
    dragging = (event)->
      distance = Math.abs drag.mousePos - event.pageX
      duration = Date.now() - drag.ts
      drag.speed = distance / duration
      drag.currentX = event.pageX
      drag.offsetX = drag.currentX - drag.initialX
      drag.mousePos = event.pageX
      drag.ts = Date.now()
      moveWrap drag.currentPos = drag.initialPos + drag.offsetX

    # move visualy, does not store the position
    moveWrap = (pos)->
      transform = " translateX(" + pos + "px) "
      nodes.wrap.node.style.webkitTransform =  transform
      nodes.wrap.node.style.msTransform = transform
      nodes.wrap.node.style.transform = transform

    # move to the desired position
    move = (pos)->
      position.current = pos
      moveWrap pos

    # ------------------------------
    # exposed methods
    # ------------------------------
    recalculate = ->
      console.log 'recalculate'

    # ------------------------------
    # init
    # ------------------------------
    init = ->
      nodes =
        parent:
          node: parentNode
          dim: getDimensions parentNode
          events: {}
        wrap:
          node: childWrapNode
          dim: getDimensions childWrapNode
          events: {}
      calcPos()
      registerEvents()
    init()

    # ------------------------------
    # exposing the party-animal API
    # ------------------------------
    recalculate: recalculate


  slider: slider