(use jaylib)
(use ./helpers)

(init-window 500 500 "Test Game")
(set-target-fps 60)
(hide-cursor)

(var player-x 250.0)
(var player-y 250.0)
(def player-speed 200)

(var has-transitioned false)
(var is-transition false)

(var camera (camera-2d :offset @[0 0] :target @[0 0] :rotation 0 :zoom 1.0))

(def room-a [0 0])
(def room-b [-500 0])
(def room-c [-500 -500])

(defn lerp [from to t]
  (if (= t 0.0)
    from
    (if (= t 1.0)
      to
      (+ from (* t (- to from))))))

(defn leave-room-a? [player-x player-y]
  (<= player-x 0))

(defn leave-room-b? [player-x player-y]
  (<= player-y 0))

(defn leave-room-c? [& args] (do))

# Returns true/false depending on how far along the animation is.
(defn camera-animation [from to seconds]
  (var elapsed 0.0)
  (var just-finished false)
  (fn [delta camera]
    (if (>= elapsed seconds)
      (do
        (if (not just-finished)
          (do
            (set (camera :target) to)
            (set just-finished true)
            true)
          true))
      (do
        (set elapsed (+ elapsed delta))
        (var progress (min (/ elapsed seconds) 1.0))
        (set (camera :target)
             [(lerp (from 0) (to 0) progress) (lerp (from 1) (to 1) progress)])
        false))))

(var should-transition? leave-room-a?)
(var animation nil)
(var current-room "A")

(while (not (window-should-close))
  (def delta (get-frame-time))
  (if (nil? animation)
    (do
      (if (key-down? :down)
        (set player-y (+ player-y (* delta player-speed))))
      (if (key-down? :up)
        (set player-y (+ player-y (- (* delta player-speed)))))
      (if (key-down? :right)
        (set player-x (+ player-x (* delta player-speed))))
      (if (key-down? :left)
        (set player-x (+ player-x (- (* delta player-speed)))))
      (if (should-transition? player-x player-y)
        (do
          (print "transitioning")
          (cond
            (= current-room "A") (set animation (camera-animation room-a room-b 0.5))
            (= current-room "B") (set animation (camera-animation room-b room-c 2.0))))))
    (do
      (if (animation delta camera)
        (do
          (print "reset animation?")
          (set animation nil)
          (set should-transition?
               (cond
                 (= current-room "A") (do (set current-room "B") leave-room-b?)
                 (= current-room "B") (do (set current-room "C") leave-room-c?)
                 (= current-room "C") (do (set current-room nil) leave-room-c?)))))))

  (draw
   (clear-background :white)
   (begin-mode-2d camera)
   (gui-grid [0 0 500 500] "GRID" 25 1 @[-1 -1])
   (draw-text "ROOM A" 0 0 10 :black)
   (draw-text "ROOM B" -500 0 10 :black)
   (draw-text "ROOM C" -500 -500 10 :black)
   (draw-circle (math/round player-x) (math/round player-y) 10 :black)
   (end-mode-2d)))
(close-window)