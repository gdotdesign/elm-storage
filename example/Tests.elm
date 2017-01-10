import Spec.Assertions exposing (..)
import Spec.Runner exposing (..)
import Spec.Steps exposing (..)
import Spec exposing (..)

import Storage.Local as Storage

import Task exposing (Task)

import Html

clear : Task String String
clear =
  Task.succeed ""
  |> Task.andThen
    (\_ ->
      case Storage.clear () of
        Err error -> Task.fail (toString error)
        Ok () -> Task.succeed "Cleared local storage"
    )

set : String -> String -> Task String String
set key value =
  Task.succeed ""
  |> Task.andThen
    (\_ ->
      case Storage.set key value of
        Err error -> Task.fail (toString error)
        Ok () -> Task.succeed ("Set value of key " ++ key ++ " to " ++ value)
    )

shouldNotHaveItem : String -> Task String String
shouldNotHaveItem key =
  Task.succeed ""
  |> Task.andThen
    (\_ ->
      case Storage.get key of
        Err error -> Task.fail (toString error)
        Ok maybeValue ->
          case maybeValue of
            Just val ->
              Task.fail "Has item"

            Nothing ->
              Task.succeed "Doesn't have key"
    )

shouldHaveItem : String -> String -> Task String String
shouldHaveItem key value =
  Task.succeed ""
  |> Task.andThen
    (\_ ->
      case Storage.get key of
        Err error -> Task.fail (toString error)
        Ok maybeValue ->
          case maybeValue of
            Just val ->
              if value == val then
                Task.succeed ("Has key " ++ key ++ " with value " ++ value)
              else
                Task.fail "Not same value"

            Nothing ->
              Task.fail "Doesn't have key"
    )

tests : Node
tests =
  describe "Storage.Local"
    [ context "set"
      [ it "should set item"
        [ shouldNotHaveItem "test"
        , set "test" "test"
        , shouldHaveItem "test" "test"
        ]
      ]
    , context "clear"
      [ it "should clear items"
        [ set "test" "test"
        , shouldHaveItem "test" "test"
        , clear
        , shouldNotHaveItem "test"
        ]
      ]
    ]


main =
  program
    { init = ""
    , view = \_ -> Html.text ""
    , update = \_ _ -> ("", Cmd.none)
    , subscriptions = \_ -> Sub.none
    }
    (flatten [] [] tests)
