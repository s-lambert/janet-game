(use jaylib)
(use ./prelude)
(use ./loaders)
(use ./autotile)

# How far into the room the player should be
(def MARGIN 10)
(def WIDTH 500)

(def bounds [0 WIDTH])

(defmacro in-room-pos [x y]
  [(+ x (bounds 0)) (+ y (bounds 1))])

(var tilemap nil)
(var tilemap-t nil)

(defn load-tilemap []
  (set tilemap (load-image-1 "assets/autotile-example.png"))
  (set tilemap-t (load-texture-from-image tilemap)))

(defn draw-room [tiles bounds]
  (if (nil? tilemap-t)
    (break))
  (each tile tiles
    (if (nil? tile) (break))
    (let [[relative-position source] tile]
      (def absolute-position (pos-add relative-position bounds))
      (draw-texture-rec tilemap-t source absolute-position :white))))

# Accounts for the player size as well, assuming it's a square.
(defn point-close-to? [bounds point]
  (def point-x (point 0))
  (def point-y (point 1))
  (def min-x (- (bounds 0) MARGIN))
  (def max-x (+ min-x WIDTH (* MARGIN 2)))
  (def min-y (- (bounds 1) MARGIN))
  (def max-y (+ min-y WIDTH (* MARGIN 2)))
  (and
   (and (>= point-x min-x) (<= point-x max-x))
   (and (>= point-y min-y) (<= point-y max-y))))

(defn leave-room? [self direction player-pos]
  (def move-to ((self :exits) direction))
  (if (and (not (nil? move-to)) (point-close-to? (move-to :bounds) player-pos))
    direction))

(defn will-player-exit [self player-pos]
  (not (nil? (some |(leave-room? self $ player-pos) [:north :east :south :west]))))

(def Room
  @{:type "Room"
    :id nil
    :bounds [0 0]
    :tiles nil # table of tables
    :exits nil # table
    :preload (fn [self]
               (load-tilemap))
    :draw (fn [self]
            (draw-room (self :tiles) (self :bounds)))
    :add-exit (fn [self direction room]
                (if (nil? ((self :exits) direction))
                  (set ((self :exits) direction) room)
                  (error (string "Room already has exit in " direction))))
    :leave-room? leave-room?
    :will-player-exit will-player-exit})

(defn make-room [room-id bounds tiles-id]
  (def tiles (autotile (load-level tiles-id)))
  (table/setproto @{:id room-id :bounds bounds :tiles tiles :exits @{}} Room))