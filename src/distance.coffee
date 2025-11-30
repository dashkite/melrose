import { row, column, start, end } from "./accessors"

# path distance (ex: up 2 over 1)
distance = ( points ) ->
  a = start points
  b = end points
  [
    ( row b ) - ( row a )
    ( column b ) - ( column a )
  ]

export { distance }