import Generic from "@dashkite/generic"
import { has } from "@dashkite/joy/object"
import { isNumber } from "@dashkite/joy/type"

fill = do ->

  ( Generic.make "fill" )

    .define [ isNumber, Array ], ( color, pixels ) ->
      for pixel in pixels
        pixel.set color

    .define [ isNumber, has "holes" ], ( color, { holes }) ->
      for hole from holes
        fill color, hole

    .define [ has "color" ], ({ color, rest... }) ->
      fill color, rest

export { fill }