# Autotiling info
# Each tile specifies the outer tiles needed like so:
# xxx
# xxx
# xxx
# Would be an empty tile that has no tiles around it, so not useful but
# xxx
# xoo
# xoo
# Is a corner tile that's filled with 1 to the east, 1 south and 1 south east
# There are 47 combinations needed to auto tile so at least 2^6 bits

(defn replace-wxyz [matrix w-val x-val y-val z-val]
  (def new-matrix @[])
  (each row matrix
    (def new-row @[])
    (each column row
      (array/push new-row (cond
                            (= column :w) w-val
                            (= column :x) x-val
                            (= column :y) y-val
                            (= column :z) z-val
                            column)))
    (array/push new-matrix new-row))
  new-matrix)

(defmacro resolve-1-duplicate [matrix]
  (def duplicates @[])
  (loop [z :range [0 2]]
    (array/push
     duplicates
     (replace-wxyz matrix 0 0 0 z)))
  ~[:has-duplicates ,;duplicates])

(defmacro resolve-2-duplicates [matrix]
  (def duplicates @[])
  (loop [y :range [0 2]]
    (loop [z :range [0 2]]
      (array/push
       duplicates
       (replace-wxyz matrix 0 0 y z))))
  ~[:has-duplicates ,;duplicates])

(defmacro resolve-3-duplicates [matrix]
  (def duplicates @[])
  (loop [x :range [0 2]]
    (loop [y :range [0 2]]
      (loop [z :range [0 2]]
        (array/push
         duplicates
         (replace-wxyz matrix 0 x y z)))))
  ~[:has-duplicates ,;duplicates])

(defmacro resolve-4-duplicates [matrix]
  (def duplicates @[])
  (loop [w :range [0 2]]
    (loop [x :range [0 2]]
      (loop [y :range [0 2]]
        (loop [z :range [0 2]]
          (array/push
           duplicates
           (replace-wxyz matrix w x y z))))))
  ~[:has-duplicates ,;duplicates])

# Refer to autotile-setup.png to see what maps to what, tiles are 20x20 with 5px
# borders. The middle bit is whether the tile is filed, the other bits are the 
# neighbours.

# r1c1 r3c1 r1c3 r3c3 are corners and don't care about the diagonals besides the inner one
# r4c1 r4c3 r1c4 r3c4 are ends and don't care about any diagonals
# r4c2 r2c4 don't care about one side being covered

(def r1c1
  (resolve-3-duplicates
   [[:x 0 :y]
    [0 1 1]
    [:z 1 1]]))

(def r1c2
  (resolve-2-duplicates
   [[:y 0 :z]
    [1 1 1]
    [1 1 1]]))

(def r1c3
  (resolve-3-duplicates
   [[:x 0 :y]
    [1 1 0]
    [1 1 :z]]))

(def r1c4
  (resolve-4-duplicates
   [[:w 0 :x]
    [0  1  0]
    [:y 1 :z]]))

(def r1c5
  (resolve-3-duplicates
   [[:x 0 :y]
    [0 1 1]
    [:z 1 0]]))

(def r1c6
  (resolve-2-duplicates
   [[:y 0 :z]
    [1 1 1]
    [1 1 0]]))

(def r1c7
  (resolve-2-duplicates
   [[:y 0 :z]
    [1 1 1]
    [0 1 1]]))

(def r1c8
  (resolve-3-duplicates
   [[:x 0 :y]
    [1 1 0]
    [0 1 :z]]))

(def r1c9
  (resolve-2-duplicates
   [[:y 0 :z]
    [1 1 1]
    [0 1 0]]))

(def r1c10
  [[1 1 0]
   [1 1 1]
   [0 1 1]])

(def r2c1
  (resolve-2-duplicates
   [[:y 1 1]
    [0 1 1]
    [:z 1 1]]))

(def r2c2
  [[1 1 1]
   [1 1 1]
   [1 1 1]])

(def r2c3
  (resolve-2-duplicates
   [[1 1 :y]
    [1 1 0]
    [1 1 :z]]))

(def r2c4
  (resolve-4-duplicates
   [[:w 1 :x]
    [0 1 0]
    [:y 1 :z]]))

(def r2c5
  (resolve-2-duplicates
   [[:y 1 1]
    [0 1 1]
    [:z 1 0]]))

(def r2c6
  [[1 1 1]
   [1 1 1]
   [1 1 0]])

(def r2c7
  [[1 1 1]
   [1 1 1]
   [0 1 1]])

(def r2c8
  (resolve-2-duplicates
   [[1 1 :y]
    [1 1 0]
    [0 1 :z]]))

(def r2c9
  [[1 1 1]
   [1 1 1]
   [0 1 0]])

(def r2c10
  [[0 1 1]
   [1 1 1]
   [1 1 0]])

(def r3c1
  (resolve-3-duplicates
   [[:x 1 1]
    [0 1 1]
    [:y 0 :z]]))

(def r3c2
  (resolve-2-duplicates
   [[1 1 1]
    [1 1 1]
    [:y 0 :z]]))

(def r3c3
  (resolve-3-duplicates
   [[1 1 :x]
    [1 1 0]
    [:z 0 :y]]))

(def r3c4
  (resolve-4-duplicates
   [[:w 1 :x]
    [0 1 0]
    [:y 0 :z]]))

(def r3c5
  (resolve-2-duplicates
   [[:y 1 0]
    [0 1 1]
    [:z 1 1]]))

(def r3c6
  [[1 1 0]
   [1 1 1]
   [1 1 1]])

(def r3c7
  [[0 1 1]
   [1 1 1]
   [1 1 1]])

(def r3c8
  (resolve-2-duplicates
   [[0 1 :y]
    [1 1 0]
    [1 1 :z]]))

(def r3c9
  [[0 1 0]
   [1 1 1]
   [1 1 1]])

(def r3c10
  [[0 1 0]
   [1 1 1]
   [0 1 1]])

(def r3c11
  [[0 1 0]
   [1 1 1]
   [1 1 0]])

(def r4c1
  (resolve-4-duplicates
   # No extra corners
   [[:w 0 :x]
    [0 1 1]
    [:y 0 :z]]))

(def r4c2
  (resolve-4-duplicates
   [[:w 0 :x]
    [1 1 1]
    [:y 0 :z]]))

(def r4c3
  (resolve-4-duplicates
   [[:w 0 :x]
    [1 1 0]
    [:y 0 :z]]))

(def r4c4
  (resolve-4-duplicates
   [[:w 0 :x]
    [0 1 0]
    [:y 0 :z]]))

(def r4c5
  (resolve-3-duplicates
   [[:x 1 0]
    [0 1 1]
    [:y 0 :z]]))

(def r4c6
  (resolve-2-duplicates
   [[1 1 0]
    [1 1 1]
    [:y 0 :z]]))

(def r4c7
  (resolve-2-duplicates
   [[0 1 1]
    [1 1 1]
    [:y 0 :z]]))

(def r4c8
  (resolve-3-duplicates
   [[0 1 :x]
    [1 1 0]
    [:y 0 :z]]))

(def r4c9
  (resolve-2-duplicates
   [[0 1 0]
    [1 1 1]
    [:y 0 :z]]))

(def r4c10
  [[0 1 1]
   [1 1 1]
   [0 1 0]])

(def r4c11
  [[1 1 0]
   [1 1 1]
   [0 1 0]])


(def r5c5
  (resolve-2-duplicates
   [[:y 1 0]
    [0 1 1]
    [:z 1 0]]))

(def r5c6
  [[1 1 0]
   [1 1 1]
   [1 1 0]])

(def r5c7
  [[0 1 1]
   [1 1 1]
   [0 1 1]])

(def r5c8
  (resolve-2-duplicates
   [[0 1 :y]
    [1 1 0]
    [0 1 :z]]))

(def r5c9
  [[0 1 0]
   [1 1 1]
   [0 1 0]])

(defmacro matrix-to-bits [matrix]
  ~(scan-number (string ;(array/concat @[] ;,matrix)) 2))

(defn array-to-bits [array]
  (scan-number (string ;array) 2))

(def combinations
  [[r1c1 r1c2 r1c3 r1c4 r1c5 r1c6 r1c7 r1c8 r1c9 r1c10]
   [r2c1 r2c2 r2c3 r2c4 r2c5 r2c6 r2c7 r2c8 r2c9 r2c10]
   [r3c1 r3c2 r3c3 r3c4 r3c5 r3c6 r3c7 r3c8 r3c9 r3c10 r3c11]
   [r4c1 r4c2 r4c3 r4c4 r4c5 r4c6 r4c7 r4c8 r4c9 r4c10 r4c11]
   [r5c5 r5c6 r5c7 r5c8 r5c9]])

(def tile-w 20)
(def tile-h 20)

(defn foo [bits-to-tile row-index column-index cell]
  (var bits (matrix-to-bits cell))
  (if (nil? (bits-to-tile bits))
    (if (= row-index 4)
      (put bits-to-tile bits
           [(* (+ 4 column-index) 20) (* row-index 20) tile-w tile-h])
      (put bits-to-tile bits
           [(* column-index 20) (* row-index 20) tile-w tile-h]))
    (error "Tile Collision")))

# Takes the bitmask of tile + neighbours and gives back the texture coords.
(def tile-lookup
  (do
    (var bits-to-tile @{})
    (loop [row-index :keys combinations]
      (var row (combinations row-index))
      (loop [column-index :keys row]
        (var cell (row column-index))
        (if (= (cell 0) :has-duplicates)
          (each duplicate (drop 1 cell)
            (foo bits-to-tile row-index column-index duplicate))
          (foo bits-to-tile row-index column-index cell))))
    bits-to-tile))

(defn get-tile [room-bits col row]
  (if (or (< col 0) (< row 0) (>= col 25) (>= row 25))
    0
    ((room-bits row) col)))

(defn autotile [room-bits]
  (var tiles @[])
  (loop [row-index :keys room-bits]
    (var row (room-bits row-index))
    (loop [column-index :keys row]
      (var tile (row column-index))
      (if (= tile 1)
        (do
          (var tile-neighbours @[])
          (for neighbour-row -1 2
               (for neighbour-col -1 2
                    (var tile-value (get-tile
                                     room-bits
                                     (+ column-index neighbour-col)
                                     (+ row-index neighbour-row)))
                    (array/push tile-neighbours
                                tile-value)))
          (var tile-pos [(* column-index 20) (* row-index 20) tile-w tile-h])
          (var tile-mask (array-to-bits tile-neighbours))
          (if (nil? (tile-lookup tile-mask))
            (error (string "Could not match neighbours" tile-neighbours))
            (array/push
             tiles
             [[(* 20 column-index) (* 20 row-index)]
              (tile-lookup tile-mask)]))))))
  tiles)
