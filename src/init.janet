(use jaylib)
(use ./prelude)
(use ./helpers)
(use ./math)
(use ./autotile)
(use ./room)
(use ./loaders)
(use ./player)
(use ./signpost)

(init-window 500 500 "Test Game")
(set-target-fps 60)
(hide-cursor)

(var camera (camera-2d :offset @[0 0] :target @[0 0] :rotation 0 :zoom 1.0))

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

(def player (setup-player))

(defn update-player-pos [new-pos]
  (set ((player :position) 0) (new-pos 0))
  (set ((player :position) 1) (new-pos 1)))

(defn update-camera-target [new-target]
  (set (camera :target) @[;new-target]))

(defn move-player-into-room [current-pos room-pos]
  (animation-fn current-pos room-pos 0.5 lerp-pos update-player-pos))

(defn move-between-rooms [from-room to-room]
  (animation-fn from-room to-room 0.5 lerp-pos update-camera-target))

(def room-a (make-room [0 0] "example"))
(def room-b (make-room [-500 0] "hello-world"))
(def room-c (make-room [-500 -500] "blank"))
(:add-exit room-a :west room-b)
(:add-exit room-b :north room-c)

(def signpost-a (make-signpost [200 200] "HELLO WORLD!"))
(def signpost-b (make-signpost [-300 200] "___________"))

# Loading
(:preload room-a)
(:preload signpost-a)

(def grass-background (color 50 177 103))

(while (not (window-should-close))
  (def delta (get-frame-time))
  (if (nil? animation)
    (do
      (:handle-input player)
      (if (should-transition? (player :position))
        (cond
          (= current-room "A")
          (do
            (set other-animation (animation-fn (array/slice (player :position)) [-10 ((player :position) 1)] 0.5 lerp-pos update-player-pos))
            (set animation (move-between-rooms (room-a :bounds) (room-b :bounds))))
          (= current-room "B")
          (do
            (set other-animation (move-player-into-room (array/slice (player :position)) [((player :position) 0) -10]))
            (set animation (move-between-rooms (room-b :bounds) (room-c :bounds)))))))
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
    (:draw room-a)
    (:draw room-b)
    (:draw signpost-a)
    (:draw signpost-b)
    (:draw player)
    (draw-text (string "ROOM " current-room) 0 0 10 :black))))
(close-window)