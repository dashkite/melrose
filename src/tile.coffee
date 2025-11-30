import { bounding } from "./bounding"
import { row, column, start, end, midpoint } from "./accessors"
import { distance } from "./distance"
import { Pixel } from "@dashkite/fairfax"

tile = ( source, target ) ->

  result = source.origin.clone()

  center = [
    ( midpoint [ 0, target.origin.rows ])
    ( midpoint [ 0, target.origin.columns ])
  ]

  # recreate the offsets from the offset grid

  offsets =
    for pixel from target.origin.entries() when pixel.value == 1
      distance [ center, pixel.index ]

  # for each pixel within each shape,
  # tile it based on the offsets

  { rest..., shapes } = source
  for shape from shapes
    # get the bounding box for the shape to tile 
    # for use in determining the new pixel location
    k = ( bounding { rest..., shape }).size
    for offset in offsets
      value = undefined
      feature = []
      previous = {}
      for pixel in shape
        scale = 0
        loop
          scale++
          p = ( row offset ) * (( row k ) - 1 )
          q = ( column offset ) * (( column k ) - 1)
          break if ( p == previous.p ) && ( q == previous.q )
          previous = { p, q }
          index = [
            ( row pixel.index ) + ( scale * p )
            ( column pixel.index ) + ( scale * q )
          ]
          if result.has index
            value ?= do ->
              _value = result.get index
              _value if _value != source.background              
            feature.push Pixel.make { pixel..., index }
          else
            break
      for pixel in feature
        result.set pixel.index, value ? pixel.value
  result

export { tile }