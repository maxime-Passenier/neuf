# example: http://www.nayuki.io/page/triangle-solver-javascript
# explained: http://users.telenet.be/chris.cambre/chris.cambre/4gon_3opldrieh.htm
define ->

  degToRad = (deg)->
    deg / 180 * Math.PI

  # Angle Side Angle
  ASA = ( A, a, B  )->
    # trigon.ASA 40.83, 6.87, 56.09
    C = 180 - A - B
    obj =
      A: A
      B: B
      C: C
      a: a
      b: (a / Math.sin(degToRad(C))) * Math.sin(degToRad(A))
      c: (a / Math.sin(degToRad(C))) * Math.sin(degToRad(B))

  # Side Angle Side
  SAS = (b, A, c)->
    # trigon.SAS 5.74, 40.83, 6.87
    a = Math.sqrt(Math.pow(b, 2) + Math.pow(c, 2) - (2 * b * c * Math.cos(degToRad(A))))
    B = (Math.sin(degToRad(A)) / a) * b
    obj =
      A : A
      B : B
      C : undefined
      a : a
      b : b
      c : c

  # the api
  ASA : ASA
  SAS : SAS