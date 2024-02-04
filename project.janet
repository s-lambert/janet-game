
  (declare-project
    :name "janet-game"
    :description ``` ```
    :version "0.0.0"
    :executable true
    :dependencies [{:url "https://github.com/s-lambert/jaylib.git" :tag "raygui-implementation"}])

  (declare-source
    :prefix "janet-game"
    :executable true
    :source ["src/init.janet"])
  