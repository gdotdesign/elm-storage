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
  , haveKeys : List String -> Task Never Outcome
  , set : String -> String -> Task Never Outcome
  , hasItem : String -> Task Never Outcome
  , remove : String -> Task Never Outcome
  , clear : Task Never Outcome
  }
localStorage =
  { remove = \key -> Steps.remove key Storage.remove
  , clear = Steps.clear Storage.clear
  , set = \key value -> Steps.set key value Storage.set
  , hasItem = \key -> Steps.hasItem key Storage.get
  , haveKeys = \keys -> Steps.haveKeys keys Storage.keys
  , doesNotHaveItem = \key ->
      Steps.hasItem key Storage.get
      |> Spec.Assertions.flip
  , valueEquals = \key value -> Steps.valueEquals key value Storage.get
  , haveNumberOfItems = \count -> Steps.haveNumberOfItems count Storage.length
  }
