(use jaylib)
(use ./helpers)
(use ./autotile)
(use ./room)

(init-window 500 500 "Tile Editor")
(set-target-fps 60)

(var grid-pos @[-1 -1])

(var tilemap-bits nil)

(load-tilemap)
(def draw-room (tilemap-drawer))

# Semi-colon separated list.
(var levels @"")
(var levels-dropdown-open false)
# Position in level dropdown that's selected
(var selected-level (gui-integer -1))

(var current-scene nil)

(defn load-menu-state []
  (set levels 
       (string/join
        (map (fn [s] (string/replace ".txt" "" s)) (os/dir "assets/levels"))
        ";")))

(defn create-new-level []
  (var empty-level @[])
  (for row-index 0 25
       (array/push empty-level (array/new-filled 25 0)))
  empty-level)

(defn load-level [id]
  (def level-path (string "assets/levels/" id ".txt"))
  (def level-file (file/open level-path :r))
  (if (nil? level-file)
    (do
      (print id level-path)
      (break)))
  (def level @[])
  (each line (file/lines level-file)
    (var line-bits @[])
    (each char (string/split " " line)
      (var parsed (scan-number char 2))
      (if (not (nil? parsed))
        (array/push line-bits parsed))
      )
    (array/push level line-bits))
  level)

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

(defn render-menu []
  (draw
   (clear-background :white)
   (if levels-dropdown-open
     (gui-lock))

   (if (gui-button [210 240 80 20] "NEW LEVEL")
     (do
       (set tilemap-bits (create-new-level))
       (set current-scene render-tile-editor)))

   (if (= (selected-level :value) -1)
     (gui-disable))
   (if (gui-button [210 280 80 20] "OPEN")
     (do
       (var levels-list (string/split ";" levels))
       (var level-index (selected-level :value))
       (if (or (= level-index -1) (>= level-index (length levels-list)))
         (do
           (print "Failed to find level" ;levels-list level-index))
         (do
           (var selected-level-name (levels-list level-index))
           (set tilemap-bits (load-level selected-level-name))
           (set current-scene render-tile-editor)))))
   (if (= (selected-level :value) -1)
     (gui-enable))

   (if levels-dropdown-open
     (gui-unlock))
   (if (empty? levels)
     (gui-disable))
   (if (gui-dropdown-box [210 260 80 20] levels selected-level levels-dropdown-open)
     (set levels-dropdown-open (not levels-dropdown-open)))
   (gui-enable)))

(load-menu-state)
(set current-scene render-menu)
(while (not (window-should-close))
  (current-scene))

(close-window)