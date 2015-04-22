# tha config
requirejs.config
  paths:
    underscore: "underscore-min"

# start the app
require [
  'lib/trigon'
], (trigon)->

  # =====================================
  # Variables
  # =====================================
  # constant
  CONSTANTS =
    domIdCanvas : 'neuf-trigon'

  # variables
  canvas = undefined
  ctx = undefined
  center =
    x: undefined
    y: undefined

  # =====================================
  # main canvas events
  # =====================================
  # set the canvas size
  size = ->
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    center.x = window.innerWidth / 2
    center.y = window.innerHeight / 2

  degToRad = (deg)->
    deg / 180 * Math.PI

  # setup the bg lines to look more scientific
  drawBg = ->
    boxSize = 10
    ctx.lineWidth = 1
    ctx.strokeStyle = "rgba(255, 255, 255, .1)"
    i = 0
    while i < canvas.width
      line i, 0, i, canvas.height
      i = i + boxSize
    i = 0
    while i < canvas.height
      line 0, i, canvas.width, i
      i = i + boxSize
    ctx.closePath()

  # just draw a bloody line
  line = (x1, y1, x2, y2)->
    ctx.beginPath()
    ctx.moveTo x1, y1
    ctx.lineTo x2, y2
    ctx.stroke()


  # =====================================
  # the tests
  # =====================================
  angle = ->
    baseX = 400
    baseY = 50
    width = 300
    line baseX, baseY, baseX + width, baseY
    circleIt = (angle)->
      x = Math.cos(degToRad(angle)) * width
      y = Math.sin(degToRad(angle)) * width
      line baseX, baseY, baseX + x, baseY + y
    circleIt 10
    circleIt 45
    circleIt 90
    circleIt 182


  # =====================================
  # And all starts here
  # =====================================
  init = ->
    canvas = document.getElementById CONSTANTS.domIdCanvas
    ctx = canvas.getContext '2d'
    size()
    drawBg()
    ctx.lineWidth = 1
    ctx.strokeStyle = "#FFFFFF"
    angle()


  init()