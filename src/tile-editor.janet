(use jaylib)
(use ./helpers)
(use ./autotile)
(use ./room)

(init-window 500 500 "Tile Editor")
(set-target-fps 60)

(var grid-pos @[-1 -1])

(var tilemap-bits @[])
(for row-index 0 25 
     (array/push tilemap-bits (array/new-filled 25 0)))

(print ;(tilemap-bits 0))

(def draw-room (tilemap-drawer))

(while (not (window-should-close))
  (draw
   (clear-background :white) 
   (draw-room (autotile tilemap-bits))
   (gui-grid [0 0 500 500] "GRID" 20 1 grid-pos)
   (if (and (mouse-button-down? :left)
            (not (deep= grid-pos @[-1 -1])))
     (let
      [[x y] grid-pos]
       (var row (tilemap-bits y))
       (set (row x) 1)))))
(close-window)