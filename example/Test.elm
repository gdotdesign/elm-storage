module Test exposing (..)

import Dict exposing (Dict)
import Native.Test
import Task exposing (Task)

import Html.Attributes exposing (style)
import Html exposing (div, strong, text)

type alias Test =
  { steps : List Step
  , results : List Bool
  , finishedSteps : List Step
  , name : String
  , id : String
  }

type alias Describe =
  { nodes : List Node
  , name : String
  }

type alias Selector = String

type Step
  = Click Selector
  | Assert Assertion Selector

type Assertion
  = TextEquals String

type Node
  = DescribeNode Describe
  | TestNode Test

type alias State a msg =
  { tests : List Test
  , finishedTests : List Test
  , app : a
  , update : msg -> a -> (a, Cmd msg)
  , view : a -> Html.Html msg
  }

type Msg msg
  = Next (Maybe Step) (Maybe Bool)
  | App msg

renderTest model =
  let
    renderLine step result =
      let
        color =
          if result then
            "green"
          else
            "red"
      in
        div [style [("color", color)]] [ text (stepToString step) ]
  in
    div []
      ([ strong [] [ text model.name ]
      ] ++ (List.map2 renderLine model.finishedSteps model.results ))

stepToString step =
  case step of
    Click selector ->
      "Click: " ++ selector
    Assert assertion selector ->
      "Assert: " ++ (toString assertion) ++ " " ++ selector

renderResults tests =
  List.map renderTest tests

program data tests =
  Html.program
    { init = ({ app = data.init, update = data.update, view = data.view, tests = tests, finishedTests = [] }, run tests)
    , update = update
    , subscriptions = (\_ -> Sub.none)
    , view = \model ->
      if List.isEmpty model.tests then
        div [] (renderResults model.finishedTests)
      else
        Html.map App (model.view model.app)
    }

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

    Next maybeStep maybeResult ->
      case model.tests of
        test :: remainingTests ->
          let
            updatedTest =
              case (maybeStep, maybeResult) of
                (Just step, Just result) ->
                  { test | results = test.results ++ [result], finishedSteps = test.finishedSteps ++ [step] }
                _ -> test
          in
            case test.steps of
              step :: remainingSteps ->
                { model
                | tests = { updatedTest | steps = remainingSteps } :: remainingTests
                } ! [ Task.perform (Next (Just step)) (Task.map Just (stepCmd step)) ]

              -- no more steps
              [] ->
                { model
                | tests = remainingTests
                , finishedTests = model.finishedTests ++ [updatedTest]
                } ! [perform (Next Nothing Nothing)]
        [] ->
          model ! []

stepCmd : Step -> Task Never Bool
stepCmd step =
  case step of
    Click selector ->
      Native.Test.click selector

    Assert assertion selector ->
      case assertion of
        TextEquals value ->
          Native.Test.assertText selector value

run : List Test -> Cmd (Msg msg)
run tests =
  case tests of
    test :: tail ->
      perform (Next Nothing Nothing)
    [] -> Cmd.none

flatten : List String -> List Test -> Node -> List Test
flatten path tests node =
  case node of
    DescribeNode node ->
      List.map (flatten (path ++ [node.name]) []) node.nodes
      |> List.foldl (++) tests

    TestNode node ->
      tests ++ [ { node | name = (String.join " " (path ++ [node.name]))  } ]

describe : String -> List Node -> Node
describe name nodes =
  DescribeNode { name = name, nodes = nodes }

it : String -> List Step -> Node
it name steps =
  TestNode { steps = steps, name = name, id = Native.Test.uid (), results = [], finishedSteps = [] }

selector : String -> String
selector = identity

click : String -> Step
click path =
  Click path

shouldHaveText : String -> Selector -> Step
shouldHaveText text selector =
  Assert (TextEquals text) selector

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
