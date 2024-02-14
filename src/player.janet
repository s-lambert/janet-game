(use jaylib) 0
(use ./prelude)

(def PLAYER_SPEED 200)

(var spritesheet nil)
(var spritesheet-t nil)

(defn preload [&]
  (set spritesheet (load-image-1 "assets/player.png"))
  (set spritesheet-t (load-texture-from-image spritesheet)))

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
            (if (key-down? :down)
              (set vertical (+ vertical (* delta PLAYER_SPEED))))
            (if (key-down? :up)
              (set vertical (- vertical  (* delta PLAYER_SPEED))))
            (if (key-down? :right)
              (set horizontal (+ horizontal (* delta PLAYER_SPEED))))
            (if (key-down? :left)
              (set horizontal (- horizontal  (* delta PLAYER_SPEED))))
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
    :move-player (fn [self new-pos]
                   (set ((self :position) 0) (new-pos 0))
                   (set ((self :position) 1) (new-pos 1)))
    :draw (fn [self]
            (draw-texture-pro spritesheet-t [0 0 20 20] [;(self :position) 40 40] [20 20] 0.0 :white))})

(defn setup-player []
  (table/setproto @{} Player))