(use jaylib)

(defmacro draw [& forms]
  ~(do
     (,begin-drawing)
     ,;forms
     (,end-drawing)))