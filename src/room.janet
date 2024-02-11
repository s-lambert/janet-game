(use jaylib)
(use ./prelude)
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
  (fn draw-room [room-bounds tile-setup]
    (if (nil? tilemap-t)
      (break))
    (each tile tile-setup
      (if (nil? tile) (break))
      (let [[relative-position source] tile]
        (def absolute-position (pos-add relative-position room-bounds))
        (draw-texture-rec tilemap-t source absolute-position :white)))))