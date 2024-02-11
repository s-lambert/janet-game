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

(defn zip-with [with-fn arr1 arr2]
  (def to-index (min (length arr1) (length arr2)))
  (def zipped @[])
  (for i 0 to-index
       (array/push zipped (with-fn (arr1 i) (arr2 i))))
  zipped)

(defn pos-add [pos-a pos-b]
  (zip-with + pos-a pos-b))

(defn tilemap-drawer []
  (fn draw-room [room-bounds tile-setup]
    (if (nil? tilemap-t)
      (break))
    (each tile tile-setup
      (if (nil? tile) (break))
      (let [[relative-position source] tile]
        (def absolute-position (pos-add relative-position room-bounds))
        (draw-texture-rec tilemap-t source absolute-position :white)))))