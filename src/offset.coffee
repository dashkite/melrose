import { bounding } from "./bounding"
import { Grid, Pixel } from "@dashkite/fairfax"
import { row, column, start, end, midpoint } from "./accessors"
import { distance } from "./distance"

odd = ( n ) -> 0 != ( n % 2 )

hash = ([ m, n ]) -> "#{ m }:#{ n }"

unique = ( ax ) ->
  seen = new Set
  for a from ax when !( seen.has (h = hash a ))
    seen.add h
    a

direction = ( f, g ) ->
  ( indices ) -> [( f row indices ), ( g column indices )]

northwest = direction start, start
north = direction start, midpoint
northeast = direction start, end
west = direction midpoint, start
east = direction midpoint, end
southwest = direction end, start
south = direction end, midpoint
southeast = direction end, end

directionals = ( subgrid ) ->
  result = []
  { indices } = subgrid
  [ m, n ] = subgrid.size
  if ( m > 2 ) && ( odd m )
    ( result.push ( east indices ), ( west indices ))
  if ( n > 2 ) && ( odd n )
    ( result.push ( north indices ), ( south indices ))
  result = [
    result...
    northwest indices
    northeast indices
    southwest indices
    southeast indices
  ]
  unique result

sum = ( ax ) ->
  ax.reduce (( x, y ) -> x + y ), 0

max = ( ax ) ->
  ax.reduce(( x, y ) -> Math.max x, y )

abs = ( ax ) -> ax.map (( x ) -> Math.abs x )

# given two sets of points, find the closest pair
closest = ( ax, bx ) ->
  d = Number.MAX_SAFE_INTEGER
  best = undefined
  for a in ax
    for b in bx
      if d > ( _d = sum abs distance [ a, b ])
        d = _d
        best = [ a, b ]
  best

# construct the offset grid from raw offsets
# (possibly containing negative numbers)
# given a set of points (pairs):
# 1. normalize them to start at [0,0]
# 2. place them on a grid
# 3. return the resulting grid
grid = ( points ) ->
  do ({ dim, m, n, delta, size, grid } = {}) ->
    dim =
      m: min: Number.MAX_SAFE_INTEGER, max: 0
      n: min: Number.MAX_SAFE_INTEGER, max: 0
    for [ m, n ] from points
      if m > dim.m.max then dim.m.max = m
      if m < dim.m.min then dim.m.min = m
      if n > dim.n.max then dim.n.max = n
      if n < dim.n.min then dim.n.min = n
    delta = 
      m: max abs [ dim.m.min, dim.m.max ]
      n: max abs [ dim.n.min, dim.n.max ]
    size =
      rows: delta.m * 2 + 1
      columns: delta.n * 2 + 1
    grid = Grid.zeros size
    for [ m, n ] from points
      grid.set [ m + delta.m, n + delta.n ], 1
    grid.set [ delta.m, delta.n ], -1
    grid

# make this generic wrt to enumerable features
offset = ( source, target ) ->
  _directionals = directionals bounding source
  grid do ->
    { shapes, rest... } = target
    for shape from shapes
      distance closest _directionals,
        directionals bounding { rest..., shape }

export { offset }
