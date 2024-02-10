(defn lerp [from to t]
  (if (<= t 0.0)
    (break from))
  (if (>= t 1.0)
    (break to))
  (+ from (* t (- to from))))

(defn lerp-pos [from to progress]
  [(lerp (from 0) (to 0) progress) (lerp (from 1) (to 1) progress)])