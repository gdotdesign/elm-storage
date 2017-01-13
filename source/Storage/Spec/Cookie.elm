module Storage.Spec.Cookie exposing (cookies)

{-| Steps and assertions for testing session storage.

@docs cookies
-}
import Spec.Assertions exposing (Outcome)
import Storage.Spec.Steps as Steps
import Storage.Cookie as Storage
import Task exposing (Task)

{-| Steps and assertions for testing session storage.
-}
cookies :
  { valueEquals : String -> String -> Task Never Outcome
  , doesNotHaveItem : String -> Task Never Outcome
  , haveNumberOfItems : Int -> Task Never Outcome
  , haveItems : List String -> Task Never Outcome
  , set : String -> String -> Task Never Outcome
  , hasItem : String -> Task Never Outcome
  , remove : String -> Task Never Outcome
  , clear : Task Never Outcome
  }
cookies =
  { haveNumberOfItems = Steps.haveNumberOfItems "the cookie store" Storage.length
  , valueEquals = Steps.valueEquals "the cookie store" Storage.get
  , haveItems = Steps.haveItems "the cookie store" Storage.keys
  , remove = Steps.remove "the cookie store" Storage.remove
  , hasItem = Steps.hasItem "the cookie store" Storage.get
  , clear = Steps.clear "visible cookie store" Storage.clear
  , set = Steps.set "the cookie store" Storage.set
  , doesNotHaveItem =
      Steps.hasItem "the cookie store" Storage.get
      >> Spec.Assertions.flip
  }
