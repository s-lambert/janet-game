(use jaylib) 0
(use ./prelude)

(def PLAYER_SPEED 200)

(var spritesheet nil)
(var spritesheet-t nil)

(defn preload [&]
  (set spritesheet (load-image-1 "assets/player.png"))
  (set spritesheet-t (load-texture-from-image spritesheet)))

(def sprite-directions
  {:up    [20 0 20 20]
   :down  [60 0 20 20]
   :left  [0 0 20 20]
   :right [40 0 20 20]})

(pp sprite-directions)
(var current-dir :up)

(def Player
  @{:position @[250.0 250.0]
    :control-state :walking-around
    :preload preload
    :handle-input
    (fn [self]
      # Debug commands
      (cond
        (key-pressed? :p) (pp (self :position)))
      # State matching.
      (let [delta (get-frame-time)]
        (cond
          (= (self :control-state) :walking-around)
          (do
            (var horizontal 0)
            (var vertical 0)
            (if (key-down? :right)
              (do (set horizontal (+ horizontal (* delta PLAYER_SPEED)))
                  (set current-dir :right)))
            (if (key-down? :left)
              (do (set horizontal (- horizontal  (* delta PLAYER_SPEED)))
                  (set current-dir :left)))
            (if (key-down? :down)
              (do (set vertical (+ vertical (* delta PLAYER_SPEED)))
                  (set current-dir :down)))
            (if (key-down? :up)
              (do (set vertical (- vertical  (* delta PLAYER_SPEED)))
                  (set current-dir :up)))
            (def pos (self :position))
            (if (not (= horizontal 0))
              (set (pos 0) (+ (pos 0) horizontal)))
            (if (not (= vertical 0))
              (set (pos 1) (+ (pos 1) vertical))))
          (= (self :control-state) :breakout)
          (do
            (var horizontal 0)
            (if (key-down? :right)
              (set horizontal (+ horizontal (* delta PLAYER_SPEED))))
            (if (key-down? :left)
              (set horizontal (- horizontal  (* delta PLAYER_SPEED))))
            (def pos (self :position))
            (if (not (= horizontal 0))
              (set (pos 0) (+ (pos 0) horizontal)))))))
    :move-player
    (fn [self new-pos]
      (set ((self :position) 0) (new-pos 0))
      (set ((self :position) 1) (new-pos 1)))
    :draw
    (fn [self]
      (draw-texture-pro
       spritesheet-t
       (sprite-directions current-dir)
       [;(self :position) 40 40]
       [20 20] 0.0 :white))})

(defn setup-player []
  (table/setproto @{} Player))