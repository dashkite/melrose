import { Grid, Subgrids } from "@dashkite/fairfax"

stamp = ({ origin: template, background, map }) ->
  background ?= -1
  [ mTemplate, nTemplate ] = template.size
  [ mMap, nMap ] = map.size
  m = mTemplate * mMap
  n = nTemplate * nMap
  result = Grid.fill background, [ m, n ]
  signals = Array.from map.values()
  subgrids = Subgrids.from result, [ mTemplate, nTemplate ]
  for subgrid from subgrids
    signal = signals.shift()
    ( template.copy subgrid ) if signal != background
  result

export { stamp }
