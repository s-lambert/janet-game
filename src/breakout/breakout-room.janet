(use ../prelude)
(use ../room)
(use ./block)

(defn make-breakout-room [existing-room]
  (def x (+ (* MARGIN 2) ((existing-room :bounds) 0)))
  (def y (+ (* MARGIN 8) ((existing-room :bounds) 1)))
  (def blocks @[])
  (for row 0 6
       (for col 0 23
            (def block-type (cond
                              (< row 2) :red
                              (< row 4) :orange
                              :yellow))
            (array/push blocks (make-block block-type [(+ x (* col 20)) (+ y (* row 20))]))))
  (set (existing-room :objects) blocks)

  (table/setproto
   @{:preload
     (fn [self]
       (:preload (table/getproto self)))
     :update
     (fn [self]
       ((table/getproto self) :update)
       (def player-x (((self :player) :position) 0))
       (def gutter (* MARGIN 3))
       (def min-bound (+ gutter ((self :bounds) 0)))
       (def max-bound (+ min-bound (- WIDTH (* 2 gutter))))
       (cond
         (> player-x max-bound) (set (((self :player) :position) 0) max-bound)
         (< player-x min-bound) (set (((self :player) :position) 0) min-bound)))
     :where-will-player-enter
     (fn [self &]
       [(+ ((self :bounds) 0) (/ WIDTH 2))
        (+ ((self :bounds) 1) 460)])
     :when-player-enters
     (fn [self player]
       (set (player :control-state) :breakout))}
   existing-room))