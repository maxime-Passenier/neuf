# tha config
requirejs.config
  paths:
    underscore: "underscore-min"

# start the app
require [
  'lib/animationFrame'
  'lib/randomizer'
], (animationFrame, randomizer)->

  # =====================================
  # Variables
  # =====================================
  # constant
  CONSTANTS =
    domIdCanvas : 'neuf-hello'

  # variables
  canvas = undefined
  ctx = undefined
  currentSize = 200
  center =
    x: undefined
    y: undefined
  lines = []


  # =====================================
  # main canvas events
  # =====================================
  # set the canvas size
  size = ->
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    center.x = window.innerWidth / 2
    center.y = window.innerHeight / 2

  # clear the canvas
  clear = ->
    ctx.clearRect 0, 0, canvas.width, canvas.height

  # degree to radiens
  degToRad = (deg)->
    deg / 180 * Math.PI

  # drawline
  drawline = (x1, y1, x2, y2)->
    ctx.beginPath()
    ctx.lineWidth = 1
    ctx.strokeStyle = "rgba(73,10,61,5)"
    ctx.moveTo(x1, y1)
    ctx.lineTo(x2, y2)
    ctx.stroke()
    ctx.closePath()

  # =====================================
  # tha balkskes
  # =====================================
  line = (angleArg=0)->
    # const
    angle = angleArg
    currentSize = 100
    targetSize = randomizer.rand 150, 300

    # draw a line
    draw = ->
      increment = if targetSize > currentSize then 1 else -1
      currentSize = currentSize + increment
#      console.log angle + ': targetSize', targetSize
      if Math.abs(currentSize - targetSize) <= 5
        targetSize = randomizer.rand 150, 300
      x = Math.cos(degToRad(angle)) * currentSize
      y = Math.sin(degToRad(angle)) * currentSize
      drawline(center.x, center.y, center.x + x, center.y + y)
    # api
    draw : draw

  # =====================================
  # anim
  # =====================================
  initAnim = ->
#    animation = animationFrame.get( anim )
#    animation.start()
#    setTimeout ->
#      animation.stop()
#    , 20000
    setInterval ->
      anim()
    , 1000


  # the animation executer
  anim = ->
    clear()
    for line in lines
      line.draw()


  # =====================================
  # And all starts here
  # =====================================
  # setup the lines
  initLines = ->
    baseLength = 200
    i = 0
    lines = []
    while i < 360
      l = line(i)
      lines.push l
      i = i + 2

  # set it up
  init = ->
    canvas = document.getElementById CONSTANTS.domIdCanvas
    ctx = canvas.getContext '2d'
    size()
    initLines()
    initAnim()

  init()