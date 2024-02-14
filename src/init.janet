(use jaylib)
(use ./prelude)
(use ./helpers)
(use ./math)
(use ./autotile)
(use ./room)
(use ./loaders)
(use ./player)
(use ./signpost)
(use ./breakout/breakout-room)
(use ./breakout/block)

(init-window 500 500 "Test Game")
(set-target-fps 60)
(hide-cursor)

(var camera (camera-2d :offset @[0 0] :target @[0 0] :rotation 0 :zoom 1.0))

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

(def player (setup-player))

(defn update-camera-target [new-target]
  (set (camera :target) @[;new-target]))

(defn move-player-into-room [current-pos room-pos]
  (animation-fn current-pos room-pos 0.5 lerp-pos |(:move-player player $)))

(defn move-between-rooms [from-room to-room]
  (animation-fn from-room to-room 0.5 lerp-pos update-camera-target))

(def room-a (make-room :a [0 0] "example"))
(def room-b (make-room :b [-500 0] "hello-world"))
(def room-c (make-breakout-room (make-room :c [0 -500] "blank")))
(def room-d (make-room :d [0 -500] "hello-world"))
(:add-exit room-a :north room-c)

(array/push (room-a :objects) (make-signpost [200 200] "HELLO WORLD!"))
(array/push (room-b :objects) (make-signpost [-350 100] "___________"))

(var current-state :within-room)

(var current-room room-a)
(set (current-room :player) player)
(var previous-room nil)

# :moving-room variables
(def animations @[])
(defn all-animations-finished? [delta]
  # and is a macro so can't be passed to reduce
  # this just invokes all of the fns and if they're all true returns true
  (reduce2 (fn [a b] (and a b)) (map |($ delta) animations)))

# Loading
(:preload player)
(:preload room-a)
(:preload room-c)
(:preload2 Block)

(def grass-background (color 50 177 103))

(while (not (window-should-close))
  (def delta (get-frame-time))
  # Update
  (cond  (= current-state :within-room)
         (do
           (:handle-input player)
           (:update current-room)
           (if-let [move-direction (:will-player-exit current-room)]
             (do
               (set current-state :moving-rooms)
               (def target-room ((current-room :exits) move-direction))
               (def new-pos (:where-will-player-enter target-room current-room move-direction))
               (array/push animations (move-player-into-room (array/slice (player :position)) new-pos))
               (array/push animations (move-between-rooms (current-room :bounds) (target-room :bounds)))
               (set previous-room current-room)
               (set current-room target-room)
               (:when-player-enters current-room player))))
         (= current-state :moving-rooms)
         (if (all-animations-finished? delta)
           (do
             (set current-state :within-room)
             (set previous-room nil)
             (set (current-room :player) player)
             (array/clear animations))))

  (draw
   (clear-background grass-background)
   (in-2d
    camera
    (:draw current-room)
    (if (not (nil? previous-room)) (:draw previous-room))

    # Entities within a room should be Y-sorted with the player but currently they're overlapping.
    (:draw player)

    (draw-text
     (string "ROOM " (string/ascii-upper (string (current-room :id))))
     ;(current-room :bounds)
     10
     :black))
   # Draw UI
   ))
(close-window)