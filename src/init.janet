(use jaylib)
(use ./helpers)

(init-window 500 500 "Test Game")
(set-target-fps 60)
(hide-cursor)

(var player-x 0.0)
(var player-y 0.0)
(def player-speed 100)

(while (not (window-should-close))
  (def delta (get-frame-time))
  (if (key-down? :down)
    (set player-y (+ player-y (* delta player-speed))))
  (if (key-down? :up)
    (set player-y (+ player-y (- (* delta player-speed)))))
  (if (key-down? :right)
    (set player-x (+ player-x (* delta player-speed))))
  (if (key-down? :left)
    (set player-x (+ player-x (- (* delta player-speed)))))

  (draw
   (clear-background :white)
   (draw-circle (math/round (+ player-x 250)) (math/round (+ player-y 250)) 10 :black)))
(close-window)