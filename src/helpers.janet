(use jaylib)

(defmacro draw [& forms]
  ~(do
     (,begin-drawing)
     ,;forms
     (,end-drawing)))

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