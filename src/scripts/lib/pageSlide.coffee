define ['lib/raf'], (raf)->

  # ==================================================
  # private stateless methods
  # ==================================================
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
    # info regarding the positioning
    position =
      current: 0

    # ------------------------------
    # internal methods
    # ------------------------------
    # calculate the elements positioning
    calcPos = ->
#      console.log nodes.parent.dim.width
#      console.log nodes.wrap.dim.width

    # register the events
    registerEvents = ->
      nodes.parent.events.mousedown = registerEvent nodes.parent.node, 'mousedown', startDrag
      nodes.parent.events.mouseup = registerEvent document, 'mouseup', stopDrag

    # when dragging starts
    startDrag = (event)->
      nodes.parent.events.mousemove = registerEvent nodes.parent.node, 'mousemove', dragging
      drag =
        initialX: event.pageX
        initialPos: position.current
        currentPos: position.current

    # when dragging starts
    stopDrag = ->
      move drag.currentPos
      drag = undefined
      nodes.parent.events.mousemove?()

    # when we are dragging the bugger
    dragging = (event)->
      drag.currentX = event.pageX
      drag.offsetX = drag.currentX - drag.initialX
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