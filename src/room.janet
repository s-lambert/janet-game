(use jaylib)
(use ./prelude)
(use ./loaders)
(use ./autotile)

(def bounds [0 500])

(defmacro in-room-pos [x y]
  [(+ x (bounds 0)) (+ y (bounds 1))])

(var tilemap nil)
(var tilemap-t nil)

(defn load-tilemap [self]
  (set tilemap (load-image-1 "assets/autotile-example.png"))
  (set tilemap-t (load-texture-from-image tilemap)))

(defn draw-room [self]
  (if (nil? tilemap-t)
    (break))
  (each tile (self :tiles)
    (if (nil? tile) (break))
    (let [[relative-position source] tile]
      (def absolute-position (pos-add relative-position (self :bounds)))
      (draw-texture-rec tilemap-t source absolute-position :white))))

(def Room
  @{:type "Room"
    :bounds [0 0]
    :tiles nil
    :preload load-tilemap
    :draw draw-room})

(defn make-room [bounds tiles-id] 
  (def tiles (autotile (load-level tiles-id)))
  (table/setproto @{:bounds bounds :tiles tiles} Room))