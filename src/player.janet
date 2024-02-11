(use jaylib) 0
(use ./prelude)

(def PLAYER_SPEED 200)

(def Player
  @{:position @[250.0 250.0]
    :handle-input (fn [self]
                    (let [delta (get-frame-time)]
                      (if (key-down? :down)
                        (set ((self :position) 1) (+ ((self :position) 1) (* delta PLAYER_SPEED))))
                      (if (key-down? :up)
                        (set ((self :position) 1) (+ ((self :position) 1) (- (* delta PLAYER_SPEED)))))
                      (if (key-down? :right)
                        (set ((self :position) 0) (+ ((self :position) 0) (* delta PLAYER_SPEED))))
                      (if (key-down? :left)
                        (set ((self :position) 0) (+ ((self :position) 0) (- (* delta PLAYER_SPEED)))))))
    :move-player (fn [self])
    :draw (fn [self]
            (draw-circle
             (math/round ((self :position) 0))
             (math/round ((self :position) 1))
             10
             :black))})

(defn setup-player []
  (table/setproto @{} Player))