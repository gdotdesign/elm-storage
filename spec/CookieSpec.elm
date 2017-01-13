import Spec.Assertions exposing (..)
import Spec.Runner exposing (..)
import Spec.Steps exposing (..)
import Spec exposing (..)

import Storage.Error exposing (Error)
import Storage.Cookie as Storage

import Steps

import Task exposing (Task, succeed)

remove : String -> Task Never Outcome
remove key =
  Steps.remove key Storage.remove

set : String -> String -> Task Never Outcome
set key value =
  Steps.set key value Storage.set

clear : Task Never Outcome
clear =
  Steps.clear Storage.clear

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
    [ context ".get"
      [ it "should get cookie"
        [ clear
        , doesNotHaveItem "test"
        , set "test" "test"
        , hasItem "test"
        ]
      ]
    , context ".set"
      [ it "should set cookie"
        [ clear
        , doesNotHaveItem "test"
        , set "test" "test"
        , valueEquals "test" "test"
        ]
      ]
    , context ".clear"
      [ it "should clear all cookies"
        [ clear
        , doesNotHaveItem "test"
        , set "test" "test"
        , set "asd" "asd"
        , hasItem "test"
        , hasItem "asd"
        , clear
        , doesNotHaveItem "test"
        , doesNotHaveItem "asd"
        ]
      ]
    , context ".remove"
      [ it "should remove a cookie"
        [ clear
        , doesNotHaveItem "test"
        , set "test" "test"
        , hasItem "test"
        , remove "test"
        , doesNotHaveItem "test"
        ]
      ]
    , context ".keys"
      [ it "should return keys"
        [ clear
        , doesNotHaveItem "test"
        , set "test" "test"
        , set "asd" "asd"
        , haveNumberOfItems 2
        , haveKeys ["asd", "test"]
        ]
      ]
    ]

main =
  Spec.Runner.run tests
