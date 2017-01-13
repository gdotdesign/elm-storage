module Storage.Local exposing (..)

import Storage.Error exposing (Error)
import Native.Storage

import Task exposing (Task)

fromFunction : (() -> Result a b) -> Task a b
fromFunction function =
  Task.succeed ()
  |> Task.andThen (\_ ->
    case function () of
      Ok value -> Task.succeed value
      Err value -> Task.fail value
  )

clear : Task Error ()
clear =
  fromFunction clearSync

clearSync : () -> Result Error ()
clearSync _ =
  Native.Storage.clear "local"

set : String -> String -> Task Error ()
set key value =
  fromFunction <| \_ -> setSync key value

setSync : String -> String -> Result Error ()
setSync key value =
  Native.Storage.set "local" key value

get : String -> Task Error (Maybe String)
get key =
  fromFunction <| \_ -> getSync key

getSync : String -> Result Error (Maybe String)
getSync key =
  Native.Storage.get "local" key

remove : String -> Task Error ()
remove key =
  fromFunction <| \_ -> removeSync key

removeSync : String -> Result Error ()
removeSync key =
  Native.Storage.remove "local" key

lengthSync : () -> Int
lengthSync _ =
  Native.Storage.length "local"

keysSync : () -> List String
keysSync _ =
  Native.Storage.keys "local"
