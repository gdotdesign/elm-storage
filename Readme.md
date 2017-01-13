# elm-storage
[![Build Status](https://travis-ci.org/gdotdesign/elm-storage.svg?branch=master)](https://travis-ci.org/gdotdesign/elm-storage)

This module provides a unified interface for accessing and modifying
**LocalStorage**, **SessionStorage** and **Cookies**

## Installation
TODO: Add to elm-package install with elm-install...

## Usage
The following functions are available for `Storage.Local`, `Storage.Session`,
and `Storage.Cookie`:

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
