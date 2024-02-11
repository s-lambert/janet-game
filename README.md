# TODO:

- Allow travelling back to other rooms.
- Implement YSorting drawable objects

Decision Log:

- Went with 20x20 tiles initially, considering bumping up to 25x25
  - With 20x20 tiles, player is larger than single tile paths
  - 20x20 tiles is 25x25 positions, which seems a bit excessive

## Janet Wiki

# File loading

(os/open path :wce)
gives a handle, that needs to be (:close handle)
can write to it with (:write handle)

# Partial Application Operator

\| can be used for partial application with $ capturing local variables eg.
(map |(string/replace ".txt" "" $) ["foo.txt" "bar.txt" "baz.txt"])
Will expand into:
(map (fn [_unique-id] (string/replace ".txt" "" $)) ["foo.txt" "bar.txt" "baz.txt"])
Works for prototypes/self methods too.
(def some-proto ...)
(def print-name |(string "Hi my name is:" (:some-method some-proto) $))
Adds the $ string after the proto name call.
