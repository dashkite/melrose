import Generic from "@dashkite/generic"
import { pipe, curry, binary } from "@dashkite/joy/function"
import { isIterable } from "@dashkite/joy/type"
import { take } from "@dashkite/river"

rand = do ->

  ( Generic.make "rand" )

    .define [], -> Math.random()

    .define [ isIterable ], ( values ) ->
      values = Array.from values
      values[ rand values.length ]

    .define [ Number ], ( value ) ->
      ( Math.floor ( Math.random() * value ))

pick2 = ( n ) ->
  a = rand n
  b = (( a + 1 + ( rand ( n - 1 ))) % n )
  [ a, b ]

# generator variant of shuffle
shuffle = ( ax ) ->
  bx = [ ax... ]
  i = bx.length
  while i > 0
    j = rand --i
    yield bx[ j ]
    bx[ j ] = bx[ i ]
  return

pick = ( m, values ) ->
  do pipe [
    -> shuffle values
    take m
    Array.from
  ]

# select index (or a corresponding value) based on a given
# set of weights. uses binary search to get O(log n)
# performance

wrand = do ->

  ( Generic.make "wrand" )

    .define [ Object ], ( values ) ->
      wrand Object.keys(), Object.values()

    .define [ isIterable, isIterable ], ( values, weights ) ->
      values = Array.from values
      weights = Array.from weights
      if values.length != weights.length
        throw new Error "wrand:
          values and weights must be the same size"
      ( Array.from values )
        .at wrand weights
            
    .define [ isIterable ], ( weights ) ->

      # normalize the weights so we can use Math.random
      # directly
      total = 0
      weights =( Array.from weights )
        .map ( weight ) -> total += weight
        .map ( weight ) -> weight / total

      # narrow the range (i, j) until we find the bin for n
      i = 0
      j = weights.length
      n = Math.random()
      while i != j
        k = i + Math.floor ( j - i ) / 2
        if weights[ k ] > n
          j = k
        else if weights[ k ] < n
          i = k + 1
        else
          i = j = k
      i

export { rand, pick2, pick, wrand, shuffle }