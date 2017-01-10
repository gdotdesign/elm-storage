module Spec.Assertions exposing (..)

import Task exposing (Task)
import Native.Spec

shouldHaveText : String -> String -> Task String String
shouldHaveText value selector =
  Native.Spec.haveText value selector
