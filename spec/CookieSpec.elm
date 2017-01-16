import Spec exposing (Node, describe, it, context, before)
import Spec.Assertions
import Spec.Runner

import Storage.Cookie exposing (SetOptions, RemoveOptions)
import Storage.Spec.Cookie exposing (cookies)


setOptions : SetOptions
setOptions =
  { secure = False
  , expires = 0.01
  , domain = ""
  , path = ""
  }


otherPathOptions : SetOptions
otherPathOptions =
  { secure = False
  , expires = 0.01
  , domain = ""
  , path = "/blah"
  }


removeOptions : RemoveOptions
removeOptions =
  { domain = ""
  , path = ""
  }


tests : Node
tests =
  describe "Storage.Cookie"
    [ before
      [ cookies.clear removeOptions
      , cookies.doesNotHaveItem "user"
      , cookies.haveNumberOfItems 0
      ]
    , context ".get"
      [ it "should get cookie"
        [ cookies.set "user" "yoda" setOptions
        , cookies.valueEquals "user" "yoda"
        ]
      ]
    , context ".set"
      [ it "should set cookie"
        [ cookies.set "user" "yoda" setOptions
        , cookies.valueEquals "user" "yoda"
        ]
      , it "should set cookie for other path"
        [ cookies.set "user" "yoda" otherPathOptions
        , cookies.doesNotHaveItem "user"
        ]
      ]
    , context ".clear"
      [ it "should clear all cookies"
        [ cookies.set "user" "yoda" setOptions
        , cookies.set "place" "jedi-temple" setOptions
        , cookies.hasItem "user"
        , cookies.hasItem "place"
        , cookies.clear removeOptions
        , cookies.doesNotHaveItem "user"
        , cookies.doesNotHaveItem "place"
        ]
      ]
    , context ".remove"
      [ it "should remove a cookie"
        [ cookies.set "user" "yoda" setOptions
        , cookies.hasItem "user"
        , cookies.remove "user" removeOptions
        , cookies.doesNotHaveItem "user"
        ]
      ]
    , context ".keys"
      [ it "should return keys"
        [ cookies.set "user" "yoda" setOptions
        , cookies.set "place" "jedi-temple" setOptions
        , cookies.haveNumberOfItems 2
        , cookies.haveItems ["place", "user"]
        ]
      ]
    ]

main =
  Spec.Runner.run tests
