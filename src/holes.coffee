import { shapes as getShapes } from "./shapes"
import { Pixel } from "@dashkite/fairfax"

offset = ( grid ) ->
  ( hole ) ->
    for pixel from hole
      Pixel.make {
        pixel...
        index: grid.offset pixel.index
      }

isBorder = ([ m, n ], pixel ) ->
  (( pixel.m == 0 ) ||
    ( pixel.n == 0 ) ||
    ( pixel.m == ( m - 1 )) ||
    ( pixel.n == ( n - 1 ))) 

isHole = ( size, background ) ->
  ( shape ) ->
    shape.every ( pixel ) ->
      ( pixel.value == background ) &&
        !( isBorder size, pixel )

holes = ({ origin, shapes, background }) ->
  shapes
    .flatMap ( shape ) ->
      grid = $.bounding { origin, shape, background }
      getShapes {
          background: -1
          origin: grid
          strict: true
        }
      .filter isHole grid.size, background
      .map offset grid

export { holes }