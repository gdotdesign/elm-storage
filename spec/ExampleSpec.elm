import Spec exposing (Node, describe, it)
import Spec.Runner

import Storage.Spec.Local exposing (localStorage)

tests : Node
tests =
  describe "Local Storage"
    [ it "should be testable"
      [ localStorage.clear
      , localStorage.set "user" "yoda"
      , localStorage.hasItem "user"
      , localStorage.valueEquals "user" "yoda"
      , localStorage.haveNumberOfItems 1
      , localStorage.haveItems ["user"]
      ]
    ]

main =
  Spec.Runner.run tests
