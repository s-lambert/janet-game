(use ../prelude)
(use ../room)

(defn make-breakout-room [existing-room]
  (table/setproto
   @{:update
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