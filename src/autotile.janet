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

# Refer to autotile-setup.png to see what maps to what, tiles are 20x20 with 5px
# borders. The middle bit is whether the tile is filed, the other bits are the 
# neighbours.
(def r1c1
  [[0 0 0]
   [0 1 1]
   [0 1 1]])

(def r1c2
  [[0 0 0]
   [1 1 1]
   [1 1 1]])

(def r1c3
  [[0 0 0]
   [1 1 0]
   [1 1 0]])

(def r1c4
  [[0 0 0]
   [0 1 0]
   [0 1 0]])

(def r1c5
  [[0 0 0]
   [0 1 1]
   [0 1 0]])

(def r1c6
  [[0 0 0]
   [1 1 1]
   [1 1 0]])

(def r1c7
  [[0 0 0]
   [1 1 1]
   [0 1 1]])

(def r1c8
  [[0 0 0]
   [1 1 0]
   [0 1 0]])

(def r1c9
  [[0 0 0]
   [1 1 1]
   [0 1 0]])

(def r1c10
  [[1 1 0]
   [1 1 1]
   [0 1 1]])

(def r2c1
  [[0 1 1]
   [0 1 1]
   [0 1 1]])

(def r2c2
  [[1 1 1]
   [1 1 1]
   [1 1 1]])

(def r2c3
  [[1 1 0]
   [1 1 0]
   [1 1 0]])

(def r2c4
  [[0 1 0]
   [0 1 0]
   [0 1 0]])

(def r2c5
  [[0 1 1]
   [0 1 1]
   [0 1 0]])

(def r2c6
  [[1 1 1]
   [1 1 1]
   [1 1 0]])

(def r2c7
  [[1 1 1]
   [1 1 1]
   [0 1 1]])

(def r2c8
  [[1 1 0]
   [1 1 0]
   [0 1 0]])

(def r2c9
  [[1 1 1]
   [1 1 1]
   [0 1 0]])

(def r2c10
  [[0 1 1]
   [1 1 1]
   [1 1 0]])

(def r3c1
  [[0 1 1]
   [0 1 1]
   [0 0 0]])

(def r3c2
  [[1 1 1]
   [1 1 1]
   [0 0 0]])

(def r3c3
  [[1 1 0]
   [1 1 0]
   [0 0 0]])

(def r3c4
  [[0 1 0]
   [0 1 0]
   [0 0 0]])

(def r3c5
  [[0 1 0]
   [0 1 1]
   [0 1 1]])

(def r3c6
  [[1 1 0]
   [1 1 1]
   [1 1 1]])

(def r3c7
  [[0 1 1]
   [1 1 1]
   [1 1 1]])

(def r3c8
  [[0 1 0]
   [1 1 0]
   [1 1 0]])

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
  [[0 0 0]
   [0 1 1]
   [0 0 0]])

(def r4c2
  [[0 0 0]
   [1 1 1]
   [0 0 0]])

(def r4c3
  [[0 0 0]
   [1 1 0]
   [0 0 0]])

(def r4c4
  [[0 0 0]
   [0 1 0]
   [0 0 0]])

(def r4c5
  [[0 1 0]
   [0 1 1]
   [0 0 0]])

(def r4c6
  [[1 1 0]
   [1 1 1]
   [0 0 0]])

(def r4c7
  [[0 1 1]
   [1 1 1]
   [0 0 0]])

(def r4c8
  [[0 1 0]
   [1 1 0]
   [0 0 0]])

(def r4c9
  [[0 1 0]
   [1 1 1]
   [0 0 0]])

(def r4c10
  [[0 1 1]
   [1 1 1]
   [0 1 0]])

(def r4c11
  [[1 1 0]
   [1 1 1]
   [0 1 0]])


(def r5c5
  [[0 1 0]
   [0 1 1]
   [0 1 0]])

(def r5c6
  [[1 1 0]
   [1 1 1]
   [1 1 0]])

(def r5c7
  [[0 1 1]
   [1 1 1]
   [0 1 1]])

(def r5c8
  [[0 1 0]
   [1 1 0]
   [0 1 0]])

(def r5c9
  [[0 1 0]
   [1 1 1]
   [0 1 0]])

(defmacro to-bits [matrix]
  ~(scan-number (string ;(array/concat @[] ;,matrix)) 2))

(def combinations
  [[r1c1 r1c2 r1c3 r1c4 r1c5 r1c6 r1c7 r1c8 r1c9]
   [r2c1 r2c2 r2c3 r2c4 r2c5 r2c6 r2c7 r2c8 r2c9]
   [r3c1 r3c2 r3c3 r3c4 r3c5 r3c6 r3c7 r3c8 r3c9 r3c10]
   [r4c1 r4c2 r4c3 r4c4 r4c5 r4c6 r4c7 r4c8 r4c9 r4c10]])

(def lookup
  (do
    (var bits-to-tile @{})
    (each row combinations
      (each column row
        (var bits (to-bits column))
        (if (nil? (bits-to-tile bits))
          (put bits-to-tile bits 
               # Replace true with the texture bounds
               true)
          (error "Tile Collision"))))
    bits-to-tile))