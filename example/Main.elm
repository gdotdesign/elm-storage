module Main exposing (..)

import Html.Events exposing (onClick)
import Html exposing (..)

import Storage.Local as Storage

type alias Model
  = List String

type Msg
  = Remove Int
  | Add

init =
  refresh ()

refresh _ =
  Storage.get "items"
    |> Result.withDefault (Just "")
    |> Maybe.withDefault ""
    |> String.split ","
    |> List.filter ((/=) "")

addItem model =
  let
    items = (toString (List.length model + 1)) :: model
  in
    case Storage.set "items" (String.join "," items) of
      Ok _ -> refresh ()
      Err err -> refresh ()

update msg model =
  case msg of
    Add ->
      ( addItem model, Cmd.none )

    Remove index ->
      ( model, Cmd.none )

subscriptions model =
  Sub.none

view model =
  div []
    [ text (toString model)
    , button [onClick Add] [text "Add"]
    ]

main =
  Html.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
