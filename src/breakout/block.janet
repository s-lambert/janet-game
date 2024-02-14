(use jaylib)
(use ../prelude)

(var spritesheet nil)
(var spritesheet-t nil)

(defn load-spritesheet []
  (set spritesheet (load-image-1 "assets/breakout-tiles.png"))
  (set spritesheet-t (load-texture-from-image spritesheet)))

(def red-texture [0 0 20 20])
(def orange-texture [0 20 20 20])
(def yellow-texture [0 40 20 20])

(var count 0)
(def Block
  @{:type nil
    :position @[0 0]
    :t-rect nil
    :preload2 (fn [self]
                (set count (+ 1 count))
                (if (> count 1) (error "Shouldn't be happening"))
                (load-spritesheet))
    :draw
    (fn [self]
      (draw-texture-rec
       spritesheet-t
       (self :t-rect)
       (self :position)
       :white))})

(defn make-block [block-type position]
  (print block-type)
  (def t-rect (cond
                (= block-type :red) red-texture
                (= block-type :orange) orange-texture
                (= block-type :yellow) yellow-texture
                (error "Unknown type")))
  (print t-rect)
  (table/setproto
   @{:type type
     :position position
     :t-rect t-rect}
   Block))