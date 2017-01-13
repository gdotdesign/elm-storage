module Storage.Cookie exposing
  ( get
  , getSync
  , set
  , setSync
  , clear
  , clearSync
  , remove
  , removeSync
  , length
  , lengthSync
  , keys
  , keysSync
  , SetOptions
  , RemoveOptions
  )

{-| Module for reading and manipulating cookies.

# Asynchronous
@docs get, set, clear, remove, length, keys

# Synchronous
@docs getSync, setSync, clearSync, removeSync, lengthSync
@docs keysSync

# Options
@docs SetOptions, RemoveOptions
-}
import Storage.Utils exposing (fromFunction)
import Storage.Error exposing (Error)
import Task exposing (Task)


{-| Options for setting cookies.
-}
type alias SetOptions =
  { domain : String
  , expires : Float
  , secure : Bool
  , path : String
  }


{-| Options for removing cookies.
-}
type alias RemoveOptions =
  { domain : String
  , path : String
  }


{-| Gets the cookie with the given key asynchronously.
-}
get : String -> Task Error (Maybe String)
get key =
  fromFunction <| \_ -> getSync key


{-| Gets an item with the given cookie synchronously.
-}
getSync : String -> Result Error (Maybe String)
getSync key =
  Native.Storage.getCookie key


{-| Sets the cookie with the given key to the given value asynchronously.
-}
set : String -> String -> SetOptions -> Task Error ()
set key value options =
  fromFunction <| \_ -> setSync key value options


{-| Sets the cookie with the given key to the given value synchronously.
-}
setSync : String -> String -> SetOptions -> Result Error ()
setSync key value options =
  Native.Storage.setCookie key value options


{-| Clears all cookies asynchronously.
-}
clear : RemoveOptions -> Task Error ()
clear options =
  fromFunction <| \_ -> clearSync options


{-| Clears all cookies synchronously.
-}
clearSync : RemoveOptions -> Result Error ()
clearSync options =
  Native.Storage.clearCookies options


{-| Removes teh cookie with the given key asynchronously.
-}
remove : String -> RemoveOptions -> Task Error ()
remove key options =
  fromFunction <| \_ -> removeSync key options


{-| Removes teh cookie with the given key synchronously.
-}
removeSync : String -> RemoveOptions -> Result Error ()
removeSync key options =
  Native.Storage.removeCookie key options


{-| Returns how many cookies the document has asynchronously.
-}
length : Task Error Int
length =
  fromFunction (lengthSync >> Ok)


{-| Returns how many cookies the document has synchronously.
-}
lengthSync : () -> Int
lengthSync _ =
  Native.Storage.cookiesLength ""


{-| Returns the names all of the cookies the document has asynchronously.
-}
keys : Task Error (List String)
keys =
  fromFunction (keysSync >> Ok)


{-| Returns the names all of the cookies the document has synchronously.
-}
keysSync : () -> List String
keysSync _ =
  Native.Storage.cookieKeys ""
