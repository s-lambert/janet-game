(use ./prelude)
(use ./room)

(defn make-breakout-room [existing-room]
  (table/setproto
   @{:where-will-player-enter (fn [self &]
                                [(+ ((self :bounds) 0) (/ WIDTH 2))
                                 (+ ((self :bounds) 1) 460)])
     :when-player-enters (fn [self player]
                           (set (player :control-state) :breakout))}
   existing-room))