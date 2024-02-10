(use jaylib)
(use ./autotile)

(def bounds [0 500])

(defmacro in-room-pos [x y]
  [(+ x (bounds 0)) (+ y (bounds 1))])

(defn tilemap-drawer []
  (def tilemap (load-image-1 "assets/autotile-example.png"))
  (def tilemap-t (load-texture-from-image tilemap))
  
  (fn draw-room [tile-setup]
    (each tile tile-setup
      (if (not (nil? tile))
        (do
          (var [position source] tile)
          (draw-texture-rec tilemap-t source position :white))))))