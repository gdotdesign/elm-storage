module Storage.Error exposing (..)

{-| This module houses the errors.

@docs Error
-}
import Native.JsCookie
import Native.Storage


{-| The following errors can happen when interacting with storage interfaces.
-}
type Error
  = QuotaExceeded
  | NotAllowed
  | Unknown
