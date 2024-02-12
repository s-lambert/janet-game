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
(def room-c (make-room :c [-500 -500] "blank"))
(:add-exit room-a :west room-b)
(:add-exit room-b :north room-c)

(var should-transition? |(:leave-room? room-a :west $))
(def leave-room-b? |(:leave-room? room-b :north $))

(defn leave-room-c? [& args] (do))

(def signpost-a (make-signpost [200 200] "HELLO WORLD!"))
(def signpost-b (make-signpost [-300 200] "___________"))

(var current-state :within-room)

(var current-room "A")

# :moving-room variables
(def animations @[])
(defn all-animations-finished? [delta]
  # and is a macro so can't be passed to reduce
  # this just invokes all of the fns and if they're all true returns true
  (reduce2 (fn [a b] (and a b)) (map |($ delta) animations)))

# Loading
(:preload room-a)
(:preload signpost-a)

(def grass-background (color 50 177 103))

(while (not (window-should-close))
  (def delta (get-frame-time))
  # Update
  (cond  (= current-state :within-room)
         (do
           (:handle-input player)
           (if (should-transition? (player :position))
             (cond
               (= current-room "A")
               (do
                 (set current-state :moving-rooms)
                 (array/push animations (animation-fn (array/slice (player :position)) [-10 ((player :position) 1)] 0.5 lerp-pos |(:move-player player $)))
                 (array/push animations (move-between-rooms (room-a :bounds) (room-b :bounds))))
               (= current-room "B")
               (do
                 (set current-state :moving-rooms)
                 (array/push animations (move-player-into-room (array/slice (player :position)) [((player :position) 0) -10]))
                 (array/push animations (move-between-rooms (room-b :bounds) (room-c :bounds)))))))
         (= current-state :moving-rooms)
         (if (all-animations-finished? delta)
           (do
             (set current-state :within-room)
             (array/clear animations)
             (set should-transition?
                  (cond
                    (= current-room "A") (do (set current-room "B") leave-room-b?)
                    (= current-room "B") (do (set current-room "C") leave-room-c?)
                    (= current-room "C") (do (set current-room nil) leave-room-c?))))))

  (draw
   (clear-background grass-background)
   (in-2d
    camera
    (:draw room-a)
    (:draw room-b)

    # Entities within a room should be Y-sorted.
    (:draw signpost-a)
    (:draw signpost-b)
    (:draw player)

    (draw-text (string "ROOM " current-room) 0 0 10 :black))
   # Draw UI
   ))
(close-window)