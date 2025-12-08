class NoOpHandler
  
  get: ( target, name ) ->
    if target[ name ].call?
      -> target
    else
      target[ name ]
      
randomly = ( base = Object ) ->

  class Randomly extends base

    @distribution:
      rarely: 0.25
      sometimes: 0.5
      often: 0.75

    randomly: ( rate = @constructor.distribution.sometimes ) ->
      if ( Math.random() < rate )
        @
      else
        new Proxy @, ( new NoOpHandler )
        
    sometimes: -> 
      @randomly @constructor.distribution.sometimes 
    
    often: ->
      @randomly @constructor.distribution.often
    
    rarely: ->
      @randomly @constructor.distribution.rarely


export { randomly }