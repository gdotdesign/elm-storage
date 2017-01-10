import App
import Html

main =
  Html.program
    { init = (App.init, Cmd.none)
    , view = App.view
    , update = App.update
    , subscriptions = App.subscriptions
    }
