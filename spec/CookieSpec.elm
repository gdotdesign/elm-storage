import Spec exposing (Node, describe, it, context)
import Spec.Assertions
import Spec.Runner

import Storage.Spec.Cookie exposing (cookies)

tests : Node
tests =
  describe "Storage.Cookie"
    [ context ".get"
      [ it "should get cookie"
        [ cookies.clear
        , cookies.doesNotHaveItem "user"
        , cookies.set "user" "yoda"
        , cookies.valueEquals "user" "yoda"
        ]
      ]
    , context ".set"
      [ it "should set cookie"
        [ cookies.clear
        , cookies.doesNotHaveItem "user"
        , cookies.set "user" "yoda"
        , cookies.valueEquals "user" "yoda"
        ]
      ]
    , context ".clear"
      [ it "should clear all cookies"
        [ cookies.clear
        , cookies.doesNotHaveItem "user"
        , cookies.set "user" "yoda"
        , cookies.set "place" "jedi-temple"
        , cookies.hasItem "user"
        , cookies.hasItem "place"
        , cookies.clear
        , cookies.doesNotHaveItem "user"
        , cookies.doesNotHaveItem "place"
        ]
      ]
    , context ".remove"
      [ it "should remove a cookie"
        [ cookies.clear
        , cookies.doesNotHaveItem "user"
        , cookies.set "user" "yoda"
        , cookies.hasItem "user"
        , cookies.remove "user"
        , cookies.doesNotHaveItem "user"
        ]
      ]
    , context ".keys"
      [ it "should return keys"
        [ cookies.clear
        , cookies.doesNotHaveItem "user"
        , cookies.set "user" "yoda"
        , cookies.set "place" "jedi-temple"
        , cookies.haveNumberOfItems 2
        , cookies.haveItems ["place", "user"]
        ]
      ]
    ]

main =
  Spec.Runner.run tests
