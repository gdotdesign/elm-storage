module Storage.Spec.Steps exposing (..)

{-| Steps and assertions for testing storage modules.
-}
import Spec.Assertions exposing (Outcome, fail, pass, error)
import Storage.Error exposing (Error)
import Task exposing (Task, succeed)


{-| Renders a message as bold.
-}
boldString : String -> String
boldString message =
  "\x1b[1m\"" ++ message ++ "\"\x1b[21m"


{-| Transforms an error to a failure.
-}
failError : a -> Task Never Outcome
failError error =
  succeed (fail ("Errored: " ++ (toString error)))


{-| Removes an item from a storage.
-}
remove : String -> (String -> Task Error ()) -> String -> Task Never Outcome
remove message task key =
  task key
  |> Task.map (\_ ->
    pass ("Removed item " ++ boldString(key) ++ " from " ++ message))
  |> Task.onError failError


{-| Clears a storage.
-}
clear : String -> Task Error () -> Task Never Outcome
clear message task =
  task
  |> Task.map (\_ -> pass ("Cleared " ++ message))
  |> Task.onError failError


{-| Sets an item in the storage.
-}
set : String -> (String -> String -> Task Error ()) -> String -> String
    -> Task Never Outcome
set message task key value =
  task key value
  |> Task.map (\_ ->
    pass ("Set value of item " ++ (boldString key) ++
          " to " ++ (boldString value) ++
          " in " ++ message))
  |> Task.onError failError


{-| Test if there are the given number of items in the storage.
-}
haveNumberOfItems : String -> Task Error Int -> Int -> Task Never Outcome
haveNumberOfItems message task count =
  task
  |> Task.map (\length ->
    if length == count then
      pass ("There are " ++ (boldString (toString count)) ++
            " items in " ++ message)
    else
      fail ("There are " ++ (boldString (toString length)) ++
            " items in " ++ message ++
            " instead of " ++ (boldString (toString count))))
  |> Task.onError failError


{-| Test if the given items equals to the items in the storage.
-}
haveItems : String -> Task Error (List String) -> List String
          -> Task Never Outcome
haveItems message task items =
  task
  |> Task.map (\currentItems ->
    if currentItems == items then
      pass ("These items " ++ (boldString (toString items)) ++
            " exists in " ++ message)
    else
      fail ("There items " ++ (boldString (toString currentItems)) ++
            " do not match the given items " ++ (boldString (toString items)) ++
            " in " ++ message ))
  |> Task.onError failError


{-| Test if the given item exists in storage.
-}
hasItem : String -> (String -> Task Error (Maybe String)) -> String
        -> Task Never Outcome
hasItem message task key =
  task key
  |> Task.map (\maybeValue ->
    case maybeValue of
      Just val ->
        pass ("Item " ++ (boldString key) ++ " exists in " ++ message)

      Nothing ->
        fail ("Item " ++ (boldString key) ++ " does not exists in " ++ message))
  |> Task.onError failError


{-| Tests if the given item in storage equals to the given value.
-}
valueEquals : String -> (String -> Task Error (Maybe String))
            -> String -> String -> Task Never Outcome
valueEquals message task key value =
  task key
  |> Task.map (\maybeValue ->
    case maybeValue of
      Just currentValue ->
        if value == currentValue then
          pass ("The value of item " ++ (boldString key) ++
                " in " ++ message ++
                " equals " ++ (boldString value))
        else
          fail ("The value " ++ (boldString currentValue) ++
                " of item " ++ (boldString key) ++
                " in " ++ message ++
                " does not equal " ++ (boldString value))

      Nothing ->
        error
          ("Item " ++ (boldString key) ++ " does not exists in " ++ message))
  |> Task.onError failError
