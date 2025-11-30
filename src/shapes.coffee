import { Pixel } from "@dashkite/fairfax"

Filters =

  strict: ( dx, dy ) ->
    ( Filters.relaxed dx, dy ) &&
      !(( Math.abs dx ) == ( Math.abs dy ))

  relaxed: ( dx, dy ) ->
    !(( dx == 0 ) && ( dy == 0 )) 

neighbors = ({ strict, data, m, n, pixel }) ->
  filter = if strict then Filters.strict else Filters.relaxed
  result = []
  for di in [ -1..1 ]
    for dj in [ -1..1 ]   
      if filter di, dj
        i = pixel.index[ 0 ] + di
        j = pixel.index[ 1 ] + dj
        if ( 0 <= i < m ) && ( 0 <= j < n )
          value = data[ i ][ j ]
          result.push Pixel.make { index: [ i, j ], value }
  result

# Mr.Rogers algorithm (visits all neighbors)
# aka rather tediously as "one component at a time"
# Possibly consider Katamari ("two-pass" algorithm)
shapes = ({ origin, background, strict }) ->

  result = []
  visited = new Set
  background ?= -1

  [ m, n ] = origin.size
  # speed is the name of the game here
  data = origin.data

  for i in [0...m]
    for j in [0...n]
      pixel = Pixel.make
        index: [ i, j ]
        value: data[ i ][ j ]
      if ( pixel.value != background ) && !( visited.has pixel.encoded )
        visited.add pixel.encoded
        pending = [ pixel ]
        result.push ( shape = [ pixel ])
        while pending.length > 0
          current = pending.pop()
          for neighbor in neighbors { strict, data, m, n, pixel: current }
            if ( neighbor.value == current.value )
              if !( visited.has neighbor.encoded )
                visited.add neighbor.encoded
                shape.push neighbor
                pending.push neighbor
  result

export { shapes }
