module Test exposing (..)

import Native.Test
import Task
import Dict exposing (Dict)

type alias Test =
  { steps : List Step
  , name : String
  , id : String
  }

type alias Describe =
  { nodes : List Node
  , name : String
  }

type alias Selector =
  { path : String
  }

type Step
  = Click Selector
  | Assert Assertion Selector

type Assertion
  = TextEquals String

type Node
  = DescribeNode Describe
  | TestNode Test

type alias State =
  { tests : List Test
  , results : Dict String (List Bool)
  }

type Msg
  = RunTest Test
  | RunStep Step

perform : Msg -> Cmd Msg
perform msg =
  Task.perform (\_ -> msg) (Task.succeed "")

process : Msg -> State -> (State, Cmd Msg)
process msg model =
  case msg of
    RunTest test ->
      -- queue step
      (model, Cmd.none)

    RunStep step ->
      -- Run step and save result
      (model, Cmd.none)

run : List Test -> Cmd Msg
run tests =
  case tests of
    test :: tail ->
      perform (RunTest test)
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
  TestNode { steps = steps, name = name, id = Native.Test.uid () }

selector : String -> Selector
selector path =
  { path = path }

click : String -> Step
click path =
  Click (selector path)

shouldHaveText : String -> Selector -> Step
shouldHaveText text selector =
  Assert (TextEquals text) selector

tests : Node
tests =
  describe "Storage.Local"
    [ it "should add item"
      [ selector "div"
        |> shouldHaveText ""
      , click "button"
      , selector "div"
        |> shouldHaveText "1"
      ]
    ]
