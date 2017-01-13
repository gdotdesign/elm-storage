module Storage.Spec.Local exposing (localStorage)

{-| Steps and assertions for testing local storage.

@docs localStorage
-}
import Spec.Assertions exposing (Outcome)
import Storage.Spec.Steps as Steps
import Storage.Local as Storage
import Task exposing (Task)

{-| Steps and assertions for testing local storage.
-}
localStorage :
  { valueEquals : String -> String -> Task Never Outcome
  , doesNotHaveItem : String -> Task Never Outcome
  , haveNumberOfItems : Int -> Task Never Outcome
  , haveItems : List String -> Task Never Outcome
  , set : String -> String -> Task Never Outcome
  , hasItem : String -> Task Never Outcome
  , remove : String -> Task Never Outcome
  , clear : Task Never Outcome
  }
localStorage =
  { haveNumberOfItems = Steps.haveNumberOfItems "local storage" Storage.length
  , valueEquals = Steps.valueEquals "local storage" Storage.get
  , haveItems = Steps.haveItems "local storage" Storage.keys
  , remove = Steps.remove "local storage" Storage.remove
  , hasItem = Steps.hasItem "local storage" Storage.get
  , clear = Steps.clear "local storage" Storage.clear
  , set = Steps.set "local storage" Storage.set
  , doesNotHaveItem =
      Steps.hasItem "local storage" Storage.get
      >> Spec.Assertions.flip
  }
