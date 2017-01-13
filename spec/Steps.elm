module Steps exposing (..)

import Spec.Assertions exposing (Outcome, fail, pass, error)
import Storage.Error exposing (Error)
import Task exposing (Task, succeed)

boldString : String -> String
boldString message =
  "\x1b[1m\"" ++ message ++ "\"\x1b[21m"

failError : a -> Task Never Outcome
failError error =
  succeed (fail ("Errored: " ++ (toString error)))

remove : String -> (String -> Task Error ()) -> Task Never Outcome
remove key task =
  task key
  |> Task.map (\_ -> pass ("Removed item "++ boldString(key)))
  |> Task.onError failError

clear : Task Error () -> Task Never Outcome
clear task =
  task
  |> Task.map (\_ -> pass "Cleared local storage")
  |> Task.onError failError

set : String -> String -> (String -> String -> Task Error ()) -> Task Never Outcome
set key value task =
  task key value
  |> Task.map (\_ ->
    pass ("Set value of key " ++ (boldString key) ++
          " to " ++ (boldString value)))
  |> Task.onError failError

hasItem : String -> (String -> Task Error (Maybe String)) -> Task Never Outcome
hasItem key task =
  task key
  |> Task.map (\maybeValue ->
    case maybeValue of
      Just val ->
        pass ("Has item with key " ++ (boldString key))

      Nothing ->
        fail ("Does not have key " ++ (boldString key)))
  |> Task.onError failError

valueEquals : String -> String -> (String -> Task Error (Maybe String)) -> Task Never Outcome
valueEquals key value task =
  task key
  |> Task.map (\maybeValue ->
    case maybeValue of
      Just val ->
        if value == val then
          pass ("The value " ++ (boldString val) ++
                " of item " ++ (boldString key) ++
                " equals value " ++ (boldString value))
        else
          fail ("The value " ++ (boldString val) ++
                " of item " ++ (boldString key) ++
                " does not equal " ++ (boldString value))

      Nothing ->
        error ("Doesn't have key " ++ (boldString key)))
  |> Task.onError failError
