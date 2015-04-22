define ->

  # generate random nr between values
  rand = (min, max, int=false)->
    if int
      Math.round(min + (max - min) * Math.random())
    else
      min + (max - min) * Math.random()

  # return a 1 in chance boolean
  casual = (chance)->
    rand(0, chance-1, true) == 0

  # public api
  rand: rand
  casual: casual