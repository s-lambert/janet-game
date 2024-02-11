(use jaylib)
(use ./prelude)
(use ./helpers)
(use ./math)
(use ./autotile)
(use ./room)
(use ./loaders)

(init-window 500 500 "Test Game")
(set-target-fps 60)
(hide-cursor)


(def player-pos @[250.0 250.0])
(def player-speed 200)

(var camera (camera-2d :offset @[0 0] :target @[0 0] :rotation 0 :zoom 1.0))

(def room-a [0 0])
(def room-b [-500 0])
(def room-c [-500 -500])

(defn leave-room-a? [position]
  (<= (position 0) 10))

(defn leave-room-b? [position]
  (<= (position 1) 10))

(defn leave-room-c? [& args] (do))

(defn animation-fn [from to seconds lerp-val set-target]
  (var elapsed 0.0)
  (var just-finished false)
  (fn [delta]
    (if (>= elapsed seconds)
      (do
        (set-target to)
        (set just-finished true)
        true)
      (do
        (set elapsed (+ elapsed delta))
        (var progress (min (/ elapsed seconds) 1.0))
        (set-target (lerp-val from to progress))
        false))))

(var should-transition? leave-room-a?)
(var animation nil)
(var other-animation nil)
(var current-room "A")

(defn update-player-pos [new-pos]
  (set (player-pos 0) (new-pos 0))
  (set (player-pos 1) (new-pos 1)))

(defn update-camera-target [new-target]
  (set (camera :target) @[;new-target]))

(defn move-player-into-room [current-pos room-pos]
  (animation-fn current-pos room-pos 0.5 lerp-pos update-player-pos))

(defn move-between-rooms [from-room to-room]
  (animation-fn from-room to-room 0.5 lerp-pos update-camera-target))

(def nine-patch (load-image-1 "assets/nine-patch-attempt.png"))
(def nine-patch-t (load-texture-from-image nine-patch))
(load-tilemap)

(def draw-room (tilemap-drawer))
(def room-tiles (autotile (load-level "example")))
(def room-b-tiles (autotile (load-level "hello-world")))
(def grass-background (color 50 177 103))

(while (not (window-should-close))
  (def delta (get-frame-time))
  (if (nil? animation)
    (do
      (if (key-down? :down)
        (set (player-pos 1) (+ (player-pos 1) (* delta player-speed))))
      (if (key-down? :up)
        (set (player-pos 1) (+ (player-pos 1) (- (* delta player-speed)))))
      (if (key-down? :right)
        (set (player-pos 0) (+ (player-pos 0) (* delta player-speed))))
      (if (key-down? :left)
        (set (player-pos 0) (+ (player-pos 0) (- (* delta player-speed)))))
      (if (should-transition? player-pos)
        (cond
          (= current-room "A")
          (do
            (set other-animation (animation-fn (array/slice player-pos) [-10 (player-pos 1)] 0.5 lerp-pos update-player-pos))
            (set animation (move-between-rooms room-a room-b)))
          (= current-room "B")
          (do
            (set other-animation (move-player-into-room (array/slice player-pos) [(player-pos 0) -10]))
            (set animation (move-between-rooms room-b room-c))))))
    (do
      (if (not (nil? other-animation)) (other-animation delta))
      (if (animation delta)
        (do
          (set animation nil)
          (set other-animation nil)
          (set should-transition?
               (cond
                 (= current-room "A") (do (set current-room "B") leave-room-b?)
                 (= current-room "B") (do (set current-room "C") leave-room-c?)
                 (= current-room "C") (do (set current-room nil) leave-room-c?)))))))

  (draw
   (clear-background grass-background)
   (in-2d
    camera
    (draw-room room-a room-tiles)
    (draw-room room-b room-b-tiles)
    # (draw-texture-n-patch nine-patch-t [[0 0 20 20] 5 5 5 5 :npatch-nine-patch] [200 200 60 40] [20 20] 0 :white)
    (draw-circle (math/round (player-pos 0)) (math/round (player-pos 1)) 10 :black))

   (draw-text (string "ROOM " current-room) 0 0 10 :black)))
(close-window)