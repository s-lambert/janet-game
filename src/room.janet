(use jaylib)
(use ./autotile)

(def bounds [0 500])

(defmacro in-room-pos [x y]
  [(+ x (bounds 0)) (+ y (bounds 1))])

(var tilemap nil)
(var tilemap-t nil)

(defn load-tilemap []
  (set tilemap (load-image-1 "assets/autotile-example.png"))
  (set tilemap-t (load-texture-from-image tilemap)))

(defn tilemap-drawer []
  (fn draw-room [tile-setup]
    (if (nil? tilemap-t)
      (break))
    (each tile tile-setup
      (if (nil? tile) (break))
      (let [[position source] tile]
        (draw-texture-rec tilemap-t source position :white)))))