port module Spec.Runner exposing (..)

import Spec.Steps
import Spec exposing (Test)

import Task

import Html.Attributes exposing (style)
import Html exposing (div, strong, text)

type alias State a msg =
  { tests : List Test
  , finishedTests : List Test
  , app : a
  , update : msg -> a -> (a, Cmd msg)
  , view : a -> Html.Html msg
  }

type Msg msg
  = Next (Maybe (Result String String))
  | App msg

perform : Msg msg -> Cmd (Msg msg)
perform msg =
  Task.perform (\_ -> msg) (Task.succeed "")

update : Msg msg -> State app msg -> (State app msg, Cmd (Msg msg))
update msg model =
  case msg of
    App appMsg ->
      let
        (app, cmd) = model.update appMsg model.app
      in
        { model | app = app } ! [Cmd.map App cmd]

    Next maybeResult ->
      case model.tests of
        test :: remainingTests ->
          let
            updatedTest =
              case maybeResult of
                Just result ->
                  { test | results = test.results ++ [result] }
                Nothing -> test
          in
            case test.steps of
              step :: remainingSteps ->
                { model
                | tests = { updatedTest | steps = remainingSteps } :: remainingTests
                } !
                [ Task.attempt (Next << Just) step
                ]

              [] ->
                { model
                | tests = remainingTests
                , finishedTests = model.finishedTests ++ [updatedTest]
                } ! [perform (Next Nothing)]
        [] ->
          model ! [report (List.map transformTest model.finishedTests)]

run : List Test -> Cmd (Msg msg)
run tests =
  case tests of
    test :: tail ->
      perform (Next Nothing)
    [] -> Cmd.none

program data tests =
  Html.program
    { init = ({ app = data.init, update = data.update, view = data.view, tests = tests, finishedTests = [] }, run tests)
    , update = update
    , subscriptions = (\_ -> Sub.none)
    , view = \model ->
      if List.isEmpty model.tests then
        Html.div [] (renderResults model.finishedTests)
      else
        Html.map App (model.view model.app)
    }

renderTest model =
  let
    renderLine result =
      let
        color =
          case result of
            Ok _ -> "green"
            Err _ -> "red"
      in
        div [style [("color", color)]] [ text (stepToString result) ]
  in
    div []
      ([ strong [] [ text model.name ]
      ] ++ (List.map renderLine model.results ))

stepToString result =
  case result of
    Ok message -> message
    Err message -> message

renderResults tests =
  List.map renderTest tests


type alias TestResult =
  { results : List { successfull : Bool, message : String }
  , name : String
  }

transformResult result =
  case result of
    Ok message -> { successfull = True, message = message }
    Err message -> { successfull = False, message = message }

transformTest test =
  { results = List.map transformResult test.results
  , name = test.name
  }

port report : List TestResult -> Cmd msg
