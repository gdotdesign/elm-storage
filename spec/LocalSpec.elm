import Spec exposing (Node, describe, it, context)
import Spec.Assertions
import Spec.Runner

import Storage.Spec.Local exposing (localStorage)

tests : Node
tests =
  describe "Storage.Local"
    [ context ".set"
      [ it "should set item"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "user"
        , localStorage.set "user" "yoda"
        , localStorage.valueEquals "user" "yoda"
        , localStorage.valueEquals "user" "obi-wan"
          |> Spec.Assertions.flip
        ]
      , it "should fail for large files"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "big-key"
        , localStorage.set "big-key" (String.repeat 50000000 "a")
          |> Spec.Assertions.flip
        , localStorage.doesNotHaveItem "big-key"
        ]
      ]
    , context ".remove"
      [ it "should remove items"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "user"
        , localStorage.set "user" "yoda"
        , localStorage.hasItem "user"
        , localStorage.remove "user"
        , localStorage.doesNotHaveItem "user"
        ]
      , it "should not fail if key is not present"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "user"
        , localStorage.remove "user"
        , localStorage.doesNotHaveItem "user"
        ]
      ]
    , context ".keys"
      [ it "should return keys"
        [ localStorage.clear
        , localStorage.haveItems []
        , localStorage.set "user" "yoda"
        , localStorage.set "place" "jedi temple"
        , localStorage.haveItems ["place", "user"]
        , localStorage.haveItems ["weapon"]
          |> Spec.Assertions.flip
        ]
      ]
    , context ".length"
      [ it "should return count of items"
        [ localStorage.clear
        , localStorage.haveNumberOfItems 0
        , localStorage.set "user" "yoda"
        , localStorage.haveNumberOfItems 1
        , localStorage.set "place" "jedi temple"
        , localStorage.haveNumberOfItems 2
        , localStorage.haveNumberOfItems 4
          |> Spec.Assertions.flip
        ]
      ]
    , context ".clear"
      [ it "should clear items"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "user"
        , localStorage.set "user" "yoda"
        , localStorage.valueEquals "user" "yoda"
        , localStorage.clear
        , localStorage.doesNotHaveItem "user"
        ]
      ]
    ]

main =
  Spec.Runner.run tests
