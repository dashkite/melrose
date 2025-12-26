import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import {
  rand
  pick2
  pick
  wrand
  shuffle
  randomly
  offset
} from "../src"

do ->

  print await test "Melrose", [

      test "rand", [

        test "rand", ->

          assert "abc".includes rand "abc"
          assert "abc".includes rand "abc"
          assert "abc".includes rand "abc"

          assert !( Number.isNaN rand())
          assert rand() < 1

        test "pick2", ->
          for i in [ 0 ... 100 ]
            result = pick2 5
            assert.equal 2, result.length
            assert result[ 0 ] != result[ 1 ]

        test "pick", ->
          for i in [ 0 ... 100 ]
            result = new Set pick 5, [ 0 ... 20 ]
            assert.equal 5, result.size


        test "wrand", ->
          weights = [ 0.5, 0.25, 0.125, 0.125 ]
          assert "abcd".includes wrand "abcd", weights
          assert "abcd".includes wrand "abcd", weights
          assert "abcd".includes wrand "abcd", weights

          t = 1e5
          results = ( new Array 4).fill 0, 0
          for i in [ 0..t ]
            results[ wrand weights ]++
          assert do ->
            results
              .map ( n, i ) -> Math.abs weights[ i ] - n/t
              .every ( delta ) -> delta < 0.01

        test "shuffle", do ->

          A = [ 1..5 ]
          it = shuffle A

          [

            test "returns a generator", ->
              assert it.next?
            
            test "produces a shuffled array", ->
              B = [( new Set it )... ]
              assert A.length == B.length
              ( assert value in B ) for value in A
              assert.notDeepEqual A, B

            test "handles singleton and null arrays", ->
              assert.deepEqual [ 0 ], Array.from shuffle [ 0 ]
              assert.deepEqual [], Array.from shuffle []

          ]

      ]

      test "randomly", ->

        class Foo extends randomly()
          
          constructor: ( @x = false ) ->
            super()
          
          bar: -> 
            @x = true
            @
              
        foo = new Foo
        for i in [1..10]
          assert foo.randomly().bar().x?

      test "offset", [

        test "nominal", ->

          # puzzle = Puzzle.make await fromTraining "045e512c"
          # theory = Theory.make puzzle, [
          #   "Shapes"     # shapes
          #   "Duplicate"  # shapes, shapes
          #   "Select"     # shapes(selected), shapes
          #   "Duplicate"  # shapes(selected), shapes(selected), shapes
          #   "Rotate"     # shapes, shapes(selected), shapes(selected)
          #   "Difference" # shapes(rest), shapes(selected)
          #   "Swap"       # shapes(selected), shapes(rest)
          # ]
          # theory.update "Select", ->
          #   @index = @selectors.findIndex ( selector ) ->
          #     selector.constructor.name == "SizeSelector"
          #   @selector.index = @selector.sizes.findIndex ( size ) ->
          #     size == "largest"
          # theory.prepare()
          # state = yield from theory.train()
          # grids = []
          # state.every ( source, target ) ->
          #   grid = offset source, target
          #   grids.push grid
          #   assert.deepEqual [ 5, 5 ], grid.size
      ]
  ]

  process.exit if success then 0 else 1
