module Storage.Local exposing
  ( clear
  , clearSync
  , set
  , setSync
  , get
  , getSync
  , remove
  , removeSync
  , length
  , lengthSync
  , keys
  , keysSync
  )

{-| LocalStorage interface offering synchronous and asynchronous functions
(tasks).

# Asynchronous
@docs get, set, clear, remove, length, keys

# Synchronous
@docs getSync, setSync, clearSync, removeSync, lengthSync, keysSync
-}
import Storage.Error exposing (Error)
import Native.Storage

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


{-| Clears local storage asynchronously.
-}
clear : Task Error ()
clear =
  fromFunction clearSync


{-| Clears local storage synchronously.
-}
clearSync : () -> Result Error ()
clearSync _ =
  Native.Storage.clear "local"


{-| Sets an item with the given key to the given value asynchronously.
-}
set : String -> String -> Task Error ()
set key value =
  fromFunction <| \_ -> setSync key value


{-| Sets an item with the given key to the given value synchronously.
-}
setSync : String -> String -> Result Error ()
setSync key value =
  Native.Storage.set "local" key value


{-| Gets an item with the given key asynchronously.
-}
get : String -> Task Error (Maybe String)
get key =
  fromFunction <| \_ -> getSync key


{-| Gets an item with the given key synchronously.
-}
getSync : String -> Result Error (Maybe String)
getSync key =
  Native.Storage.get "local" key


{-| Removes an item with the given key asynchronously.
-}
remove : String -> Task Error ()
remove key =
  fromFunction <| \_ -> removeSync key


{-| Removes an item with the given key synchronously.
-}
removeSync : String -> Result Error ()
removeSync key =
  Native.Storage.remove "local" key


{-| Returns how many items are in the local storage asynchronously.
-}
length : Task Error Int
length =
  fromFunction (lengthSync >> Ok)


{-| Returns how many items are in the local storage synchronously.
-}
lengthSync : () -> Int
lengthSync _ =
  Native.Storage.length "local"


{-| Returns the keys of the items in local storage asynchronously.
-}
keys : Task Error (List String)
keys =
  fromFunction (keysSync >> Ok)


{-| Returns the keys of the items in local storage synchronously.
-}
keysSync : () -> List String
keysSync _ =
  Native.Storage.keys "local"
