(use jaylib)
(use ./helpers)

(init-window 500 500 "Test Game")
(set-target-fps 60)
(hide-cursor)

(var player-x 0.0)
(var player-y 0.0)
(def player-speed 100)

(var has-transitioned false)
(var is-transition false)

(var camera (camera-2d :offset @[250 250] :target @[0 0] :rotation 0 :zoom 1.0))

(while (not (window-should-close))
  (def delta (get-frame-time))
  (if (not is-transition)
    (do
      (if (key-down? :down)
        (set player-y (+ player-y (* delta player-speed))))
      (if (key-down? :up)
        (set player-y (+ player-y (- (* delta player-speed)))))
      (if (key-down? :right)
        (set player-x (+ player-x (* delta player-speed))))
      (if (key-down? :left)
        (set player-x (+ player-x (- (* delta player-speed)))))
      (if (and (not has-transitioned) (< player-x -250))
        (do (print "transitioning")
            (set is-transition true))))
    (do
      (def offset-x (+ ((camera :offset) 0) 10))
      (set (camera :offset) [offset-x 250])
      (print ((camera :offset) 0))
      (if (>= ((camera :offset) 0) 750)
        (do (set is-transition false)
            (set has-transitioned true)
            (set (camera :offset) [750 250])))))


  (if (key-down? :space)
    (set (camera :offset) [10 10]))

  (draw
   (clear-background :white)
   (begin-mode-2d camera)
   (draw-text "ROOM A" 0 0 10 :black)
   (draw-text "ROOM B" -500 0 10 :black)
   (draw-circle (math/round player-x) (math/round player-y) 10 :black)
   (end-mode-2d)))
(close-window)