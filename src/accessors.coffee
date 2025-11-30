row = start = ( indices ) -> indices[0]

column = end = ( indices ) -> indices[1]

midpoint = ( range ) -> 
  ( start range ) +
    Math.floor((( end range ) - ( start range ))/2)


export { row, column, start, end, midpoint }