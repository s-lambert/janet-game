# TODO:

- Allow travelling back to other rooms.
- Implement YSorting drawable objects
- Move around preload, putting it on each object sucks when there's multiple
- Create a scene abstraction at the top level for communicating between states isnteadm of hardcoding

# UNBLOCKERS

- Tile editor saves without spaces and has an extra newline at the end.
- Look at usage of var, probably not needed in a lot of cases.
- Rooms probably should just be bi-directional and then have special cases for boss-like rooms.

Decision Log:

- Went with 20x20 tiles initially, considering bumping up to 25x25
  - With 20x20 tiles, player is larger than single tile paths
  - 20x20 tiles is 25x25 positions, which seems a bit excessive

## Janet Wiki

# Case statement (a.k.a match)

```clj
(defn quadrant [[x y]]
  (case [(neg? x) (neg? y)]
    [false false] 3
    [true false] 2
    [true true] 1
    [false true] 0))
```

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
