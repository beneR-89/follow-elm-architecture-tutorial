module Msgs exposing (..)

import Models exposing (Player, PlayerId)
import RemoteData exposing (WebData)
import Navigation  exposing (Location)
import Http

type Msg
  = OnFetchPlayers (WebData (List Player))
  | OnLocationChange Location
  | ChangeLevel Player Int
  | OnPlayerSave (Result Http.Error Player)
  | OnUpdateFuturePlayerName String
  | OnUpdateFuturePlayerLevel String
  | OnCreatePlayer Player
  | OnPlayerCreated (Result Http.Error Player)
  | OnDeletePlayer PlayerId
  | OnPlayerDeleted (Result Http.Error PlayerId)
