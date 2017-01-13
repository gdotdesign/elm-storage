import Spec.Assertions exposing (..)
import Spec.Runner exposing (..)
import Spec.Steps exposing (..)
import Spec exposing (..)

import Storage.Error exposing (Error)
import Storage.Session as Storage

import Storage.Spec.Steps as Steps

import Task exposing (Task, succeed)

remove : String -> Task Never Outcome
remove key =
  Steps.remove key Storage.remove

clear : Task Never Outcome
clear =
  Steps.clear Storage.clear

set : String -> String -> Task Never Outcome
set key value =
  Steps.set key value Storage.set

hasItem : String -> Task Never Outcome
hasItem key =
  Steps.hasItem key Storage.get

haveKeys : List String -> Task Never Outcome
haveKeys keys =
  Steps.haveKeys keys Storage.keys

doesNotHaveItem : String -> Task Never Outcome
doesNotHaveItem key =
  Steps.hasItem key Storage.get
  |> Spec.Assertions.flip

valueEquals : String -> String -> Task Never Outcome
valueEquals key value =
  Steps.valueEquals key value Storage.get

haveNumberOfItems : Int -> Task Never Outcome
haveNumberOfItems count =
  Steps.haveNumberOfItems count Storage.length

tests : Node
tests =
  describe "Storage.Local"
    [ context ".set"
      [ it "should set item"
        [ doesNotHaveItem "test"
        , set "test" "test"
        , valueEquals "test" "test"
        ]
      , it "should fail for large files"
        [ clear
        , doesNotHaveItem "test"
        , set "test" (String.repeat 50000000 "a")
          |> Spec.Assertions.flip
        ]
      ]
    , context ".remove"
      [ it "should remove items"
        [ clear
        , doesNotHaveItem "test"
        , set "test" "test"
        , hasItem "test"
        , remove "test"
        , doesNotHaveItem "test"
        ]
      , it "should not fail if key is not present"
        [ clear
        , doesNotHaveItem "test"
        , remove "test"
        , doesNotHaveItem "test"
        ]
      ]
    , context ".keys"
      [ it "should return keys"
        [ clear
        , haveKeys []
        , set "test" "test"
        , set "asd" "asd"
        , haveKeys ["asd", "test"]
        ]
      ]
    , context ".length"
      [ it "should return count of items"
        [ clear
        , haveNumberOfItems 0
        , set "test" "test"
        , haveNumberOfItems 1
        , set "asd" "asd"
        , haveNumberOfItems 2
        ]
      ]
    , context ".clear"
      [ it "should clear items"
        [ clear
        , doesNotHaveItem "test"
        , set "test" "test"
        , valueEquals "test" "test"
        , clear
        , doesNotHaveItem "test"
        ]
      ]
    ]

main =
  Spec.Runner.run tests
