(import jaylib :as jl)

(jl/init-window 500 500 "Test Game")
(jl/set-target-fps 60)
(jl/hide-cursor)

(while (not (jl/window-should-close))
  (jl/begin-drawing)

  (jl/clear-background [0 0 0])
  (let [[x y] (jl/get-mouse-position)]
    (jl/draw-circle-gradient (math/floor x) (math/floor y) 31.4 :lime :red)
    (jl/draw-poly [500 200] 5 40 0 :magenta)
    (jl/draw-line-bezier
      [(- x 100) y]
      [(+ x 100) (+ y 50)]
      4 :pink)
    (jl/draw-line-ex
      [x (- y 10)]
      [x (+ y 10)]
      4 :sky-blue)
    (jl/draw-line-strip
      [[x 0] [x 100] [50 y] [10 180]]
      :ray-white))

  (jl/end-drawing))

(jl/close-window)