(use jaylib)
(use ./prelude)

(var nine-patch nil)
(var nine-patch-t nil)

(defn load-signpost []
  (set nine-patch (load-image-1 "assets/nine-patch-attempt.png"))
  (set nine-patch-t (load-texture-from-image nine-patch)))

# [[texture position and size] up down left right nine|only-horziontall|only-vertical ]
(def nine-patch-info [[0 0 20 20] 5 5 5 5 :npatch-nine-patch])

(defn draw-signpost [self]
  (draw-texture-n-patch
   nine-patch-t
   nine-patch-info
   [;(self :position) 60 40]
   [20 20]
   0
   :white))

(def Signpost
  @{:type "Signpost"
    :position [0 0]
    :text "DEBUG"
    :self draw-signpost
    :preload (fn [self] (load-signpost))
    :draw draw-signpost})

(defn make-signpost [position text]
  (table/setproto @{:position position :text text} Signpost))
# (draw-texture-n-patch nine-patch-t [[0 0 20 20] 5 5 5 5 :npatch-nine-patch] [200 200 60 40] [20 20] 0 :white)
