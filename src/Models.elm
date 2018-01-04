module Models exposing (..)

import RemoteData exposing (WebData)

type alias Model =
  {
    players: WebData (List Player),
    playerToBeCreated: Player,
    route: Route
  }

initialModel : Route -> Model
initialModel route =
  {
    players = RemoteData.Loading,
    playerToBeCreated = Player "" "" -1,
    route = route
  }

type alias PlayerId = String

type alias Player =
  {
    id: PlayerId,
    name: String,
    level: Int
  }

type Route
  = PlayersRoute
  | PlayerRoute PlayerId
  | CreatePlayerRoute
  | NotFoundRoute
