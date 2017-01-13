module Storage.Session exposing
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

{-| Module for manipulating session storage.

# Asynchronous
@docs get, set, clear, remove, length, keys

# Synchronous
@docs getSync, setSync, clearSync, removeSync, lengthSync, keysSync
-}
import Storage.Utils exposing (fromFunction)
import Storage.Error exposing (Error)
import Task exposing (Task)


{-| Clears session storage asynchronously.
-}
clear : Task Error ()
clear =
  fromFunction clearSync


{-| Clears session storage synchronously.
-}
clearSync : () -> Result Error ()
clearSync _ =
  Native.Storage.clear "session"


{-| Sets an item with the given key to the given value asynchronously.
-}
set : String -> String -> Task Error ()
set key value =
  fromFunction <| \_ -> setSync key value


{-| Sets an item with the given key to the given value synchronously.
-}
setSync : String -> String -> Result Error ()
setSync key value =
  Native.Storage.set "session" key value


{-| Gets an item with the given key asynchronously.
-}
get : String -> Task Error (Maybe String)
get key =
  fromFunction <| \_ -> getSync key


{-| Gets an item with the given key synchronously.
-}
getSync : String -> Result Error (Maybe String)
getSync key =
  Native.Storage.get "session" key


{-| Removes an item with the given key asynchronously.
-}
remove : String -> Task Error ()
remove key =
  fromFunction <| \_ -> removeSync key


{-| Removes an item with the given key synchronously.
-}
removeSync : String -> Result Error ()
removeSync key =
  Native.Storage.remove "session" key


{-| Returns how many items are in the session storage asynchronously.
-}
length : Task Error Int
length =
  fromFunction (lengthSync >> Ok)


{-| Returns how many items are in the session storage synchronously.
-}
lengthSync : () -> Int
lengthSync _ =
  Native.Storage.length "session"


{-| Returns the keys of the items in session storage asynchronously.
-}
keys : Task Error (List String)
keys =
  fromFunction (keysSync >> Ok)


{-| Returns the keys of the items in session storage synchronously.
-}
keysSync : () -> List String
keysSync _ =
  Native.Storage.keys "session"
