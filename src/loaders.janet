(defn level-path [id]
  (string "assets/levels/" id ".txt"))

(defn load-level [id]
  (def this-level-path (level-path id))
  (def level-file (file/open this-level-path :r))
  (if (nil? level-file)
    (do
      (print id level-path)
      (break)))
  (def level @[])
  (each line (file/lines level-file)
    (var line-bits @[])
    (each char (string/split " " line)
      (var parsed (scan-number char 2))
      (if (not (nil? parsed))
        (array/push line-bits parsed)))
    (array/push level line-bits))
  (file/close level-file)
  level)