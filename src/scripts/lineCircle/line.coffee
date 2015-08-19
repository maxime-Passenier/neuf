define ->

  # degree to radiens
  degToRad = (deg)->
    deg / 180 * Math.PI

  # ========================================
  # generate a line obj
  # ========================================
  getLine = (ctxArg)->
    # --------------------------------------
    # variables
    # --------------------------------------
    ctx = ctxArg
    if !ctx.canvas?
      throw "defined context is not a canvas"
    s = 5 # the length increment of a step
    x = undefined # base x position
    y = undefined # base y position
    a = undefined # angle
    r = undefined # radiens
    l = undefined # length
    tl = undefined # target length
    min_l = undefined # minimum length
    max_l = undefined # minimum length

    # --------------------------------------
    # attribute setters/getters
    # --------------------------------------
    # set the x ref
    setRefPoint = (xArg, yArg)->
      x = xArg
      y = yArg

    # set the lines angle
    setAngle = (angleArg)->
      r = angleArg / 180 * Math.PI

    # set the length
    setLength = (lArg)->
      l = lArg

    # set the minimum length
    setMinLength = (lArg)->
      min_l = lArg

    # set the minimum length
    setMaxLength = (lArg)->
      max_l = lArg


    # --------------------------------------
    # drawing the stuff
    # --------------------------------------
    getLength = ->
#      tl = max_l if !tl?
#      if tl > l and l+s>tl

    draw = ->
      getLength()
      x2 = x + (Math.cos(r) * l)
      y2 = y+ (Math.sin(r) * l)
      ctx.beginPath()
      ctx.lineWidth = 1
      ctx.strokeStyle = "rgba(124, 97, 70, 0.5)"
      ctx.moveTo(x, y)
      ctx.lineTo(x2, y2)
      ctx.stroke()
      ctx.closePath()


    # --------------------------------------
    # api
    # --------------------------------------
    setRefPoint : setRefPoint
    setAngle : setAngle
    setLength : setLength
    setMinLength : setMinLength
    setMaxLength : setMaxLength
    draw : draw


  # the api
  getLine : getLine