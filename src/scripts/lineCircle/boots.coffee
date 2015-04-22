# bootstrap file
require [
  '../lib/randomizer'
  '../lib/animationFrame'
  'line'
], (randomizer, animationFrame, line)->

  # constants
  CONSTANTS =
    domIdCanvas: "neuf-canvas"
    degBetweenLines: 2
    minLength: 50
    maxLength: 250
  # globals
  canvas = undefined
  ctx = undefined
  lines = []

  # ========================================
  # main canvas fn
  # ========================================
  # setup canvas size
  setCanvasSize = ->
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight


  # ========================================
  # for the lines
  # ========================================
  # setup the lines
  initLines = ->
    lines = []
    i = 0
    length = 10
    while i < 360
      l = new line.getLine ctx, 100
      l.setRefPoint canvas.width/2, canvas.height/2
      l.setAngle i
      l.setLength length
      l.setMinLength CONSTANTS.minLength
      l.setMaxLength CONSTANTS.maxLength
      l.draw()
      lines.push l
      length = length + 1
      i = i + CONSTANTS.degBetweenLines


  # ========================================
  # init
  # ========================================
  init = ->
    canvas = document.getElementById CONSTANTS.domIdCanvas
    ctx = canvas.getContext '2d'
    setCanvasSize()
    initLines()


  init()
