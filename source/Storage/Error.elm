module Storage.Error exposing (..)

{-| This module houses the errors.

@docs Error
-}

{-| The following errors can happen when interacting with storage interfaces.
-}
type Error
  = QuotaExceeded
  | NotAllowed
  | Unknown
