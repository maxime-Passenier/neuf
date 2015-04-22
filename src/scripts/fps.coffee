# tha config
requirejs.config
  paths:
    underscore: "underscore-min"

# start the app
require [
  'lib/randomizer'
  'lib/animationFrame'
], (randomizer, animationFrame)->

  # =====================================
  # Variables
  # =====================================
  # constant
  CONSTANTS =
    domIdCanvas : 'neuf-canvas'
    domIdSvg : 'neuf-svg'

  # variables
  canvas = undefined
  canvasAnimation = undefined
  svgAnimation = undefined
  canvassing = false
  ctx = undefined
  svg = undefined
  xmlns = "http://www.w3.org/2000/svg"

  # =====================================
  # canvas
  # =====================================
  # set the canvas size
  size = ->
    canvas.width = window.innerWidth/2
    canvas.height = window.innerHeight
    svg.setAttributeNS(null, "width", window.innerWidth/2)
    svg.setAttributeNS(null, "height", window.innerHeight)

  clear = ->
    ctx.clearRect 0, 0, canvas.width, canvas.height

  toggleAnim = ->
    canvassing = !canvassing
    if canvassing
      canvasAnimation.start()
      svgAnimation.stop()
    else
      canvasAnimation.stop()
      svgAnimation.start()

  doTheCanvas = ->
    lines = []
    min = 0
    max = window.innerHeight
    # draw a line
    drawline = (x1, y1, x2, y2)->
      ctx.beginPath()
      ctx.lineWidth = 1
      ctx.strokeStyle = "white"
      ctx.moveTo(x1, y1)
      ctx.lineTo(x2, y2)
      ctx.stroke()
      ctx.closePath()
    # line class
    getLineObj = (xArg, yArg)->
      x = xArg
      y = yArg
      cheight = randomizer.rand( min, max, true )
      tHeight = randomizer.rand( min, max, true )
      draw = ->
        incr = if cheight < tHeight then 1 else -1
        cheight = cheight + incr
        drawline x, y, x, y-cheight
        if cheight == tHeight
          tHeight = randomizer.rand( min, max, true )
      draw : draw
    # setup the classes
    setup = ->
      i = 0
      while i < window.innerWidth/2
        line = getLineObj( i, window.innerHeight)
        line.draw()
        lines.push line
        i = i + 3
    step = ->
      clear()
      for l in lines
        l.draw()
    setup()
    canvasAnimation = animationFrame.get( step )
    canvas.addEventListener 'click', ->
      toggleAnim()

  doTheSvg = ->
    lines = []
    min = 0
    max = window.innerHeight
    getLineObj = (parentNode, xArg, yArg)->
      line = undefined
      cheight = randomizer.rand( min, max, true )
      tHeight = randomizer.rand( min, max, true )
      createLine = ->
        line = document.createElementNS xmlns, 'line'
        line.setAttributeNS(null, 'class', 'th-line')
        line.setAttributeNS(null, 'x1', xArg)
        line.setAttributeNS(null, 'y1', yArg)
        line.setAttributeNS(null, 'x2', xArg)
        line.setAttributeNS(null, 'y2', yArg-100)
        parentNode.appendChild line
        line
      line = createLine()
      draw = ->
        incr = if cheight < tHeight then 1 else -1
        cheight = cheight + incr
        line.setAttributeNS(null, 'y2', yArg-cheight)
        if cheight == tHeight
          tHeight = randomizer.rand( min, max, true )
      draw: draw
    setup = ->
      i = 10
      while i < window.innerWidth/2
        line = getLineObj svg, i, window.innerHeight
        line.draw()
        lines.push line
        i = i + 3
    step = ->
      for l in lines
        l.draw()
    setup()
    svgAnimation = animationFrame.get( step )
    svg.addEventListener 'click', ->
      toggleAnim()

  # =====================================
  # And all starts here
  # =====================================
  init = ->
    canvas = document.getElementById CONSTANTS.domIdCanvas
    svg = document.getElementById CONSTANTS.domIdSvg
    ctx = canvas.getContext '2d'
    size()
    doTheCanvas()
    doTheSvg()


  init()