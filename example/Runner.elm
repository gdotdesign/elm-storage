import App
import Test exposing (..)

tests : Node
tests =
  describe "Storage.Local"
    [ it "should add item"
      [ selector "div span"
        |> shouldHaveText "[]"
      , click "button"
      , selector "div span"
        |> shouldHaveText "[\"1\"]"
      ]
    , it "should remove item"
      [ click "button"
      , shouldHaveText "[\"1\"]" "div span"
      ]
    ]


main =
  Test.program
    { init = App.init
    , view = App.view
    , update = App.update
    , subscriptions = App.subscriptions
    }
    (Test.flatten [] [] tests)
