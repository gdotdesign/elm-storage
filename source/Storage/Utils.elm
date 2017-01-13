module Storage.Utils exposing (..)

import Task exposing (Task)

{-| Transforms a function into a task.
-}
fromFunction : (() -> Result a b) -> Task a b
fromFunction function =
  Task.succeed ()
  |> Task.andThen (\_ ->
    case function () of
      Ok value -> Task.succeed value
      Err value -> Task.fail value
  )
