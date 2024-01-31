
  (declare-project
    :name "janet-game"
    :description ``` ```
    :version "0.0.0"
    :executable true
    :dependencies ["https://github.com/janet-lang/jaylib"])

  (declare-source
    :prefix "janet-game"
    :executable true
    :source ["src/init.janet"])
  