(use jaylib) 0
(use ./prelude)

(def PLAYER_SPEED 200)

(def Player
  @{:position @[250.0 250.0]
    :handle-input (fn [self]
                    (let [delta (get-frame-time)]
                      (var horizontal 0)
                      (var vertical 0)
                      (if (key-down? :down)
                        (set vertical (+ vertical (* delta PLAYER_SPEED))))
                      (if (key-down? :up)
                        (set vertical (- vertical  (* delta PLAYER_SPEED))))
                      (if (key-down? :right)
                        (set horizontal (+ horizontal (* delta PLAYER_SPEED))))
                      (if (key-down? :left)
                        (set horizontal (- horizontal  (* delta PLAYER_SPEED))))
                      (if (not (= horizontal 0))
                        (set ((self :position) 0) (+ ((self :position) 0) horizontal)))
                      (if (not (= vertical 0))
                        (set ((self :position) 1) (+ ((self :position) 1) vertical)))))
    :move-player (fn [self new-pos]
                   (set ((self :position) 0) (new-pos 0))
                   (set ((self :position) 1) (new-pos 1)))
    :draw (fn [self]
            (draw-circle
             (math/round ((self :position) 0))
             (math/round ((self :position) 1))
             10
             :black))})

(defn setup-player []
  (table/setproto @{} Player))