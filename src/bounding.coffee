import Generic from "@dashkite/generic"
import { has } from "@dashkite/joy/object"
import { Grid, Subgrid } from "@dashkite/fairfax"

_bounding = ( shapes ) ->
  min = m: Number.MAX_SAFE_INTEGER, n: Number.MAX_SAFE_INTEGER
  max = m: 0, n: 0
  for shape in shapes
    for pixel from shape
      if pixel.m < min.m then min.m = pixel.m
      if pixel.m > max.m then max.m = pixel.m
      if pixel.n < min.n then min.n = pixel.n
      if pixel.n > max.n then max.n = pixel.n
  [[ min.m, max.m ], [ min.n, max.n ]]

bounding = do ->

  ( Generic.make "bounding" )

    .define [ has "shape" ], ({ origin, shape, background }) ->
      bounding { origin, shapes: [ shape ], background }
  
    .define [ has "shapes" ], ({ origin, shapes, background }) ->
      background ?= -1
      grid = Grid.fill background, origin.size
      grid.draw shapes
      Subgrid.make grid, _bounding shapes

export { bounding }