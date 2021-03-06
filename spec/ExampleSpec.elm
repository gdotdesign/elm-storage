import Spec exposing (..)

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
  run tests
