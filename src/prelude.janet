(def TILE-W 20)
(def TILE-H 20)

(defn zip-with [with-fn arr1 arr2]
  (def to-index (min (length arr1) (length arr2)))
  (def zipped @[])
  (for i 0 to-index
       (array/push zipped (with-fn (arr1 i) (arr2 i))))
  zipped)

(defn pos-add [pos-a pos-b]
  (zip-with + pos-a pos-b))

# Colors need to be 0 < c <=1
(defmacro color [hex-r hex-g hex-b]
  ~'[,(/ hex-r 255) ,(/ hex-g 255) ,(/ hex-b 255)])