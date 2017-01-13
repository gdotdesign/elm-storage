module Storage.Spec.Cookie exposing (cookies)

{-| Steps and assertions for testing session storage.

@docs cookies
-}
import Storage.Cookie as Storage exposing (SetOptions, RemoveOptions)
import Storage.Spec.Steps as Steps exposing (boldString, failError)
import Storage.Error exposing (Error)

import Spec.Assertions exposing (Outcome, pass, fail)

import Task exposing (Task)

{-| Removes an item from a storage.
-}
remove : (String -> RemoveOptions -> Task Error ()) -> String -> RemoveOptions
       -> Task Never Outcome
remove task key options =
  task key options
  |> Task.map (\_ ->
    pass ("Removed item " ++ boldString(key) ++
          " with options" ++ (boldString (toString options)) ++
          " from the cookie store"))
  |> Task.onError failError


{-| Clears a storage.
-}
clear : (RemoveOptions -> Task Error ()) -> RemoveOptions -> Task Never Outcome
clear task options =
  task options
  |> Task.map (\_ ->
    pass ("Cleared the cookie store with options " ++
          (boldString (toString options))))
  |> Task.onError failError


{-| Sets an item in the storage.
-}
set : (String -> String -> SetOptions -> Task Error ()) -> String -> String
    -> SetOptions -> Task Never Outcome
set task key value options =
  task key value options
  |> Task.map (\_ ->
    pass ("Set value of item " ++ (boldString key) ++
          " to " ++ (boldString value) ++
          " in the cookie store"))
  |> Task.onError failError

{-| Steps and assertions for testing session storage.
-}
cookies :
  { set : String -> String -> SetOptions -> Task Never Outcome
  , remove : String -> RemoveOptions -> Task Never Outcome
  , valueEquals : String -> String -> Task Never Outcome
  , doesNotHaveItem : String -> Task Never Outcome
  , haveNumberOfItems : Int -> Task Never Outcome
  , haveItems : List String -> Task Never Outcome
  , clear : RemoveOptions -> Task Never Outcome
  , hasItem : String -> Task Never Outcome
  }
cookies =
  { haveNumberOfItems = Steps.haveNumberOfItems "the cookie store" Storage.length
  , valueEquals = Steps.valueEquals "the cookie store" Storage.get
  , haveItems = Steps.haveItems "the cookie store" Storage.keys
  , hasItem = Steps.hasItem "the cookie store" Storage.get
  , remove = remove Storage.remove
  , clear = clear Storage.clear
  , set = set Storage.set
  , doesNotHaveItem =
      Steps.hasItem "the cookie store" Storage.get
      >> Spec.Assertions.flip
  }
