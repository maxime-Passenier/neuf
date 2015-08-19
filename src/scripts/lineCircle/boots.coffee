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
    totalDeg : 360
    lineIncrement : 5
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
    add = true
    while i < CONSTANTS.totalDeg
      l = new line.getLine ctx, 100
      l.setRefPoint canvas.width/2, canvas.height/2
      l.setAngle i
      l.setLength length
      l.setMinLength 10
      l.setMaxLength canvas.width/2
      l.draw()
      lines.push l
      length = if add then length + CONSTANTS.lineIncrement else length - CONSTANTS.lineIncrement
      i = i + CONSTANTS.degBetweenLines
      if add and i > CONSTANTS.totalDeg/2
        console.log 'change direction'
        add = false

  # draw the lines
  draw = ->




  # ========================================
  # init
  # ========================================
  init = ->
    canvas = document.getElementById CONSTANTS.domIdCanvas
    ctx = canvas.getContext '2d'
    setCanvasSize()
    initLines()
    draw()


  init()
