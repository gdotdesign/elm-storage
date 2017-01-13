import Spec.Runner exposing (..)
import Spec.Steps exposing (..)
import Spec exposing (..)
import Spec.Assertions

import Storage.Spec.Local exposing (localStorage)

tests : Node
tests =
  describe "Storage.Local"
    [ context ".set"
      [ it "should set item"
        [ localStorage.doesNotHaveItem "test"
        , localStorage.set "test" "test"
        , localStorage.valueEquals "test" "test"
        ]
      , it "should fail for large files"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "test"
        , localStorage.set "test" (String.repeat 50000000 "a")
          |> Spec.Assertions.flip
        ]
      ]
    , context ".remove"
      [ it "should remove items"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "test"
        , localStorage.set "test" "test"
        , localStorage.hasItem "test"
        , localStorage.remove "test"
        , localStorage.doesNotHaveItem "test"
        ]
      , it "should not fail if key is not present"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "test"
        , localStorage.remove "test"
        , localStorage.doesNotHaveItem "test"
        ]
      ]
    , context ".keys"
      [ it "should return keys"
        [ localStorage.clear
        , localStorage.haveKeys []
        , localStorage.set "test" "test"
        , localStorage.set "asd" "asd"
        , localStorage.haveKeys ["asd", "test"]
        ]
      ]
    , context ".length"
      [ it "should return count of items"
        [ localStorage.clear
        , localStorage.haveNumberOfItems 0
        , localStorage.set "test" "test"
        , localStorage.haveNumberOfItems 1
        , localStorage.set "asd" "asd"
        , localStorage.haveNumberOfItems 2
        ]
      ]
    , context ".clear"
      [ it "should clear items"
        [ localStorage.clear
        , localStorage.doesNotHaveItem "test"
        , localStorage.set "test" "test"
        , localStorage.valueEquals "test" "test"
        , localStorage.clear
        , localStorage.doesNotHaveItem "test"
        ]
      ]
    ]

main =
  Spec.Runner.run tests
