(use jaylib)

(defmacro draw [& forms]
  ~(do
     (,begin-drawing)
     ,;forms
     (,end-drawing)))

(defmacro in-2d [camera & forms]
  ~(do
     (,begin-mode-2d camera)
     ,;forms
     (,end-mode-2d)))

# Example usage:
# 
# (define-grid 5 5)
#(var _1x1 [75 25])
# 
# (draw-square c1 r1 ;_1x1) 
(defmacro define-grid [cols rows]
  (var defs @[])
  (var col-prefix "c")
  (for i 0 cols
       (array/push defs ~(def ,(symbol (string col-prefix (+ i 1))) ,(* 25 i))))
  (var row-prefix "r")
  (for i 0 rows
       (array/push defs ~(def ,(symbol (string row-prefix (+ i 1))) ,(* 25 i))))
  ~(upscope ,;defs))

# Replaces a symbol with a value in an array
(defmacro replace-5 [arr]
  (def new-array @[])
  (each item arr (if (= item 5) (array/push new-array 4) (array/push item)))
  ~,new-array)

# Replaces a symbol with a value in a matrix
(defmacro replace-symbol [matrix symbol value]
  (def new-matrix @[])
  (each row matrix
    (def new-row @[])
    (each column row
      (if (= column symbol)
        (array/push new-row value)
        (array/push new-row column)))
    (array/push new-matrix new-row))
  ~,new-matrix)