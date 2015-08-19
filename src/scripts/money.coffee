# tha config
requirejs.config
  paths:
    underscore: "underscore-min"

# start the app
require [], ->

  amountTwist = (element)->

    CONST =
      nrOfDigits: 9
      digitPrefix: 'orc-amount-twist__digit'
      nrOfDecimal: 2
      decimalPrefix: 'orc-amount-twist__decimal'
      digitMappingPrefix: 'orc-amount-twist__digit--value-'
      digitMapping:
        '0': '0'
        '1': '1'
        '2': '2'
        '3': '3'
        '4': '4'
        '5': '5'
        '6': '6'
        '7': '7'
        '8': '8'
        '9': '9'
        '-': 'minus'
        'none': 'none'

    digit = (element)->
      initClassName = element.className

      set = (digit)->
        if digit?
          className = CONST.digitMappingPrefix + CONST.digitMapping[digit]
        else
          className = CONST.digitMappingPrefix + CONST.digitMapping['none']
        element.className = initClassName + ' ' + className

      set: set

    nodes =
      digit: {}
      decimal: {}

    loadNodes = ->
      i = 1
      while i <= CONST.nrOfDigits
        nodes.digit[i] = digit element.querySelector('.' + CONST.digitPrefix + i)
        i++
      i = 1
      while i <= CONST.nrOfDecimal
        nodes.decimal[i] = digit element.querySelector('.' + CONST.decimalPrefix + i)
        i++

    setValue = (value)->
      valueObj = convertValue value
      nodes.decimal[2].set valueObj.decimal[1]
      nodes.decimal[1].set valueObj.decimal[0]
      i = 1
      while i <= CONST.nrOfDigits
        digit =  valueObj.digit[ i - 1]
        nodes.digit[i].set digit
        i++

    convertValue = (nr)->
      return false if isNaN(nr * 1)
      obj = {}
      str = nr.toString()
      decimalPlace = str.indexOf '.'
      if decimalPlace == -1
        fullnr = str
        obj.decimal = ['0', '0']
      else
        fullnr = str.substr 0, decimalPlace
        decimals = str.substr decimalPlace + 1, 2
        obj.decimal = explodeNumber decimals
        if obj.decimal.length < 2
          obj.decimal.push '0'
      obj.digit = explodeNumber fullnr
      if obj.digit.length < 1
        obj.digit.push '0'
      obj.negative = nr < 0
      obj

    explodeNumber = (nr)->
      arr = []
      i = 0
      l = nr.length
      while i < l
        arr.unshift nr.charAt(i)
        i++
      arr

    do ->
      loadNodes()

    setValue: setValue



  number = amountTwist document.querySelector('.orc-amount-twist')

  saldo = 3452.12
  number.setValue saldo
  controller = document.querySelector('#controller')
  controller.onkeyup = (event)->
    amount = controller.value
    console.log 'saldo - amount', Math.round( saldo - amount )

    number.setValue Math.round( (saldo - amount) * 100 ) / 100



