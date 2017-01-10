module Spec.Steps exposing (..)

import Task exposing (Task)

click : String -> Task String String
click selector =
  Native.Spec.click selector
