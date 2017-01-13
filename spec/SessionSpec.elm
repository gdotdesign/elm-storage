import Spec exposing (Node, describe, it, context)
import Spec.Assertions
import Spec.Runner

import Storage.Spec.Session exposing (sessionStorage)

tests : Node
tests =
  describe "Storage.Session"
    [ context ".set"
      [ it "should set item"
        [ sessionStorage.clear
        , sessionStorage.doesNotHaveItem "user"
        , sessionStorage.set "user" "yoda"
        , sessionStorage.valueEquals "user" "yoda"
        , sessionStorage.valueEquals "user" "obi-wan"
          |> Spec.Assertions.flip
        ]
      , it "should fail for large files"
        [ sessionStorage.clear
        , sessionStorage.doesNotHaveItem "big-key"
        , sessionStorage.set "big-key" (String.repeat 50000000 "a")
          |> Spec.Assertions.flip
        , sessionStorage.doesNotHaveItem "big-key"
        ]
      ]
    , context ".remove"
      [ it "should remove items"
        [ sessionStorage.clear
        , sessionStorage.doesNotHaveItem "user"
        , sessionStorage.set "user" "yoda"
        , sessionStorage.hasItem "user"
        , sessionStorage.remove "user"
        , sessionStorage.doesNotHaveItem "user"
        ]
      , it "should not fail if key is not present"
        [ sessionStorage.clear
        , sessionStorage.doesNotHaveItem "user"
        , sessionStorage.remove "user"
        , sessionStorage.doesNotHaveItem "user"
        ]
      ]
    , context ".keys"
      [ it "should return keys"
        [ sessionStorage.clear
        , sessionStorage.haveItems []
        , sessionStorage.set "user" "yoda"
        , sessionStorage.set "place" "jedi temple"
        , sessionStorage.haveItems ["place", "user"]
        , sessionStorage.haveItems ["weapon"]
          |> Spec.Assertions.flip
        ]
      ]
    , context ".length"
      [ it "should return count of items"
        [ sessionStorage.clear
        , sessionStorage.haveNumberOfItems 0
        , sessionStorage.set "user" "yoda"
        , sessionStorage.haveNumberOfItems 1
        , sessionStorage.set "place" "jedi temple"
        , sessionStorage.haveNumberOfItems 2
        , sessionStorage.haveNumberOfItems 4
          |> Spec.Assertions.flip
        ]
      ]
    , context ".clear"
      [ it "should clear items"
        [ sessionStorage.clear
        , sessionStorage.doesNotHaveItem "user"
        , sessionStorage.set "user" "yoda"
        , sessionStorage.valueEquals "user" "yoda"
        , sessionStorage.clear
        , sessionStorage.doesNotHaveItem "user"
        ]
      ]
    ]

main =
  Spec.Runner.run tests
