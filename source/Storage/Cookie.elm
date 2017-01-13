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
  )

import Storage.Utils exposing (fromFunction)
import Storage.Error exposing (Error)
import Task exposing (Task)


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
set : String -> String -> Task Error ()
set key value =
  fromFunction <| \_ -> setSync key value


{-| Sets the cookie with the given key to the given value synchronously.
-}
setSync : String -> String -> Result Error ()
setSync key value =
  Native.Storage.setCookie key value


{-| Clears all cookies asynchronously.
-}
clear : Task Error ()
clear =
  fromFunction clearSync


{-| Clears all cookies synchronously.
-}
clearSync : () -> Result Error ()
clearSync _ =
  Native.Storage.clearCookies ""


{-| Removes teh cookie with the given key asynchronously.
-}
remove : String -> Task Error ()
remove key =
  fromFunction <| \_ -> removeSync key


{-| Removes teh cookie with the given key synchronously.
-}
removeSync : String -> Result Error ()
removeSync key =
  Native.Storage.removeCookie key


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
