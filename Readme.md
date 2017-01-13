# elm-storage
[![Build Status](https://travis-ci.org/gdotdesign/elm-storage.svg?branch=master)](https://travis-ci.org/gdotdesign/elm-storage)

This module provides a unified interface for accessing and modifying
**LocalStorage**, **SessionStorage** and **Cookies**.

## Installation
Add `gdotdesign/elm-storage` to your dependencies:

```json
"dependencies": {
  "gdotdesign/elm-storage": "1.0.0 <= v < 2.0.0"
}
```

And install with [elm-github-install](https://github.com/gdotdesign/elm-github-install) using the `elm-install` command.

## Usage
The following functions are available for `Storage.Local`, `Storage.Session`:

```elm
-- Asynchronous
get : String -> Task Error (Maybe String)
set : String -> String -> Task Error ()
remove : String -> Task Error ()
keys : Task Error (List String)
length : Task Error Int
clear : Task Error ()

-- Synchronous
getSync : String -> Result Error (Maybe String)
setSync : String -> String -> Result Error ()
keysSync : () -> Result Error (List String)
removeSync : String -> Result Error ()
length : () -> Result Error Int
clear : () -> Result Error ()
```

and a slightly different version for `Storage.Cookie`:

```elm
-- Asynchronous
set : String -> String -> SetOptions -> Task Error ()
remove : String -> RemoveOptions -> Task Error ()
get : String -> Task Error (Maybe String)
clear : RemoveOptions -> Task Error ()
keys : Task Error (List String)
length : Task Error Int

-- Synchronous
setSync : String -> String -> SetOptions -> Result Error ()
removeSync : String -> RemoveOptions -> Result Error ()
getSync : String -> Result Error (Maybe String)
keysSync : () -> Result Error (List String)
clear : RemoveOptions -> Result Error ()
length : () -> Result Error Int

-- Options
type alias SetOptions =
  { domain : String
  , expires : Float
  , secure : Bool
  , path : String
  }
  
type alias RemoveOptions =
  { domain : String
  , path : String
  }
```

## Testing
The module contains **steps and assertions** to use with [elm-spec](https://github.com/gdotdesign/elm-spec). Check out the [specs](spec) on how to use them, and here is a quick example:

```elm
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
```
