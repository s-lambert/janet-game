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

(load-tilemap)
(def draw-room (tilemap-drawer))

# Semi-colon separated list.
(var levels @"")
(var levels-dropdown-open false)
# Position in level dropdown that's selected
(var selected-level (gui-integer -1))

(defn load-menu-state []
  (set levels 
       (string/join
        (map (fn [s] (string/replace ".txt" "" s)) (os/dir "assets/levels"))
        ";")))

(defn render-menu []
  (draw
   (clear-background :white)
   (if levels-dropdown-open
     (gui-lock))

   (gui-button [210 240 80 20] "NEW LEVEL")

   (if (= (selected-level :value) -1)
     (gui-disable))
   (gui-button [210 280 80 20] "OPEN")
   (if (= (selected-level :value) -1)
     (gui-enable))

   (if levels-dropdown-open
     (gui-unlock))
   (if (empty? levels)
     (gui-disable))
   (if (gui-dropdown-box [210 260 80 20] levels selected-level levels-dropdown-open)
     (set levels-dropdown-open (not levels-dropdown-open)))
   (gui-enable)))

(defn render-tile-editor []
  (draw
   (clear-background :white)
   (draw-room (autotile tilemap-bits))
   (gui-grid [0 0 500 500] "GRID" 20 1 grid-pos)

   (var is-grid-hovered (not (deep= grid-pos @[-1 -1])))
   (if (and (mouse-button-down? :left) is-grid-hovered)
     (let
      [[x y] grid-pos]
       (var row (tilemap-bits y))
       (set (row x) 1)))
   (if (and (mouse-button-down? :right) is-grid-hovered)
     (let
      [[x y] grid-pos]
       (var row (tilemap-bits y))
       (set (row x) 0)))

   (if (and (key-pressed? :s) (key-down? :left-control))
     (do
       (var tile-txt
            (string/join (map (fn to-str [line] (string ;line)) tilemap-bits) "\n"))
       (print tile-txt)))))

(load-menu-state)
(while (not (window-should-close))
  (render-menu))

(close-window)