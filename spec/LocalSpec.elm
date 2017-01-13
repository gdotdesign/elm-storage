import Spec.Assertions exposing (..)
import Spec.Runner exposing (..)
import Spec.Steps exposing (..)
import Spec exposing (..)

import Storage.Local as Storage

import Task exposing (Task, succeed)

clear : Task Never Outcome
clear =
  succeed ""
  |> Task.map
    (\_ ->
      case Storage.clear () of
        Err error -> fail (toString error)
        Ok () -> pass "Cleared local storage"
    )

set : String -> String -> Task Never Outcome
set key value =
  succeed ""
  |> Task.map
    (\_ ->
      case Storage.set key value of
        Err error -> fail (toString error)
        Ok () -> pass ("Set value of key " ++ key ++ " to " ++ value)
    )

shouldNotHaveItem : String -> Task Never Outcome
shouldNotHaveItem key =
  succeed ""
  |> Task.map
    (\_ ->
      case Storage.get key of
        Err error -> fail (toString error)
        Ok maybeValue ->
          case maybeValue of
            Just val ->
              pass "Has item"

            Nothing ->
              pass "Doesn't have key"
    )

shouldHaveItem : String -> String -> Task Never Outcome
shouldHaveItem key value =
  succeed ""
  |> Task.map
    (\_ ->
      case Storage.get key of
        Err error -> fail (toString error)
        Ok maybeValue ->
          case maybeValue of
            Just val ->
              if value == val then
                pass ("Has key " ++ key ++ " with value " ++ value)
              else
                fail "Not same value"

            Nothing ->
              fail "Doesn't have key"
    )

tests : Node
tests =
  describe "Storage.Local"
    [ context ".set"
      [ it "should set item"
        [ shouldNotHaveItem "test"
        , set "test" "test"
        , shouldHaveItem "test" "test"
        ]
      ]
    , context ".clear"
      [ it "should clear items"
        [ set "test" "test"
        , shouldHaveItem "test" "test"
        , clear
        , shouldNotHaveItem "test"
        ]
      ]
    ]

main =
  Spec.Runner.run tests
