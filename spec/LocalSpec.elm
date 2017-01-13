import Spec.Assertions exposing (..)
import Spec.Runner exposing (..)
import Spec.Steps exposing (..)
import Spec exposing (..)

import Storage.Error exposing (Error)
import Storage.Local as Storage

import Steps

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

doesNotHaveItem : String -> Task Never Outcome
doesNotHaveItem key =
  Steps.hasItem key Storage.get
  |> Spec.Assertions.flip

valueEquals : String -> String -> Task Never Outcome
valueEquals key value =
  Steps.valueEquals key value Storage.get

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
