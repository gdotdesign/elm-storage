module Storage.Spec.Session exposing (sessionStorage)

{-| Steps and assertions for testing session storage.

@docs sessionStorage
-}
import Spec.Assertions exposing (Outcome)
import Storage.Spec.Steps as Steps
import Storage.Session as Storage
import Task exposing (Task)

{-| Steps and assertions for testing session storage.
-}
sessionStorage :
  { valueEquals : String -> String -> Task Never Outcome
  , doesNotHaveItem : String -> Task Never Outcome
  , haveNumberOfItems : Int -> Task Never Outcome
  , haveItems : List String -> Task Never Outcome
  , set : String -> String -> Task Never Outcome
  , hasItem : String -> Task Never Outcome
  , remove : String -> Task Never Outcome
  , clear : Task Never Outcome
  }
sessionStorage =
  { haveNumberOfItems = Steps.haveNumberOfItems "session storage" Storage.length
  , valueEquals = Steps.valueEquals "session storage" Storage.get
  , haveItems = Steps.haveItems "session storage" Storage.keys
  , remove = Steps.remove "session storage" Storage.remove
  , hasItem = Steps.hasItem "session storage" Storage.get
  , clear = Steps.clear "session storage" Storage.clear
  , set = Steps.set "session storage" Storage.set
  , doesNotHaveItem =
      Steps.hasItem "session storage" Storage.get
      >> Spec.Assertions.flip
  }
