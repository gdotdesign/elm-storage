module Storage.Local exposing (..)

import Storage.Error exposing (Error)
import Native.Storage

clear : () -> Result Error ()
clear _ =
  Native.Storage.clear "local"

set : String -> String -> Result Error ()
set key value =
  Native.Storage.set "local" key value

get : String -> Result Error (Maybe String)
get key =
  Native.Storage.get "local" key

remove : String -> Result Error ()
remove key =
  Native.Storage.remove "local" key

length : () -> Int
length _ =
  Native.Storage.length "local"

keys : () -> List String
keys _ =
  Native.Storage.keys "local"
