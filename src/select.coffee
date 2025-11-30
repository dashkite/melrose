import Generic from "@dashkite/generic"
import { has } from "@dashkite/joy/object"

Size =

  largest: ( features ) ->
    largest = -1
    result = []
    for current from features
      # TODO alternative: compute area of bounding grid
      if current.length > largest
        largest = current.length
        result = [ current ]
      else if current.length == largest
        result.push current
    result
  
  smallest: ( features ) ->
    smallest = Number.MAX_SAFE_INTEGER
    result = []
    for current from features
      # TODO alternative: compute area of bounding grid
      if current.length < smallest
        smallest = current.length
        result = [ current ]
      else if current.length == smallest
        result.push current
    result

select = do ->

  ( Generic.make "select" )

    .define [( has "color" ), Array ], ({ color }, features ) ->
      features
        .filter ( pixels ) ->
          pixels.every ( pixel ) -> 
            pixel.value == color

    .define [( has "size" ), Array ], ({ size }, features ) ->
      Size[ size ].call null, features
  
reject = do ->

  ( Generic.make "reject" )

    .define [( has "color" ), Array ], ({ color }, features ) ->
      features
        .filter ( pixels ) ->
          pixels.every ( pixel ) -> 
            pixel.value != color

    .define [( has "size" ), Array ], ({ size }, features ) ->
      selected = Size[ size ].call null, features
      features.filter ( feature ) -> !( feature in selected )
      
export { select, reject }