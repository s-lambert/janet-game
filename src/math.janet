(defn lerp [from to t]
  (if (<= t 0.0)
    from
    (if (>= t 1.0)
      to
      (+ from (* t (- to from))))))

(defn lerp-pos [from to progress]
  [(lerp (from 0) (to 0) progress) (lerp (from 1) (to 1) progress)])