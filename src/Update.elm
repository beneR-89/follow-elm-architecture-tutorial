module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model, Player)
import Routing exposing (parseLocation)
import Commands exposing (savePlayerCmd, fetchPlayers, createPlayerCmd, deletePlayerCmd)
import RemoteData

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Msgs.OnFetchPlayers response ->
      ( { model | players = response }, Cmd.none )
    Msgs.OnLocationChange location ->
      let
        newRoute = parseLocation location
      in
        ( { model | route = newRoute }, Cmd.none )
    Msgs.ChangeLevel player howMuch ->
      let
        updatedPlayer = { player | level = player.level + howMuch }
      in
        ( model, savePlayerCmd updatedPlayer )
    Msgs.OnPlayerSave (Ok player) ->
      ( updatePlayer model player, Cmd.none )
    Msgs.OnPlayerSave (Err error) ->
      ( model, Cmd.none )
    Msgs.OnUpdateFuturePlayerName name ->
      let
        level = model.playerToBeCreated.level
        player = Player "" name level
      in
        ( { model | playerToBeCreated = player }, Cmd.none )
    Msgs.OnUpdateFuturePlayerLevel level ->
      let
        name = model.playerToBeCreated.name
        player = Player "" name (parseLevel level)
      in
        ( { model | playerToBeCreated = player }, Cmd.none )
    Msgs.OnCreatePlayer player ->
      ( model, createPlayerCmd player )
    Msgs.OnPlayerCreated (Ok player) ->
      ( { model | playerToBeCreated = Player "" "" -1 }, fetchPlayers )
    Msgs.OnPlayerCreated (Err error) ->
      ( { model | playerToBeCreated = Player "" "" -1 }, Cmd.none )
    Msgs.OnDeletePlayer id ->
      ( model, deletePlayerCmd id )
    Msgs.OnPlayerDeleted (Ok id) ->
      ( model, fetchPlayers )
    Msgs.OnPlayerDeleted (Err err) ->
      ( model, Cmd.none )

updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
  let
    pick : Player -> Player
    pick currentPlayer =
      if updatedPlayer.id == currentPlayer.id then
        updatedPlayer
      else
        currentPlayer

    updatePlayerList : List Player -> List Player
    updatePlayerList players = List.map pick players

    updatedPlayers = RemoteData.map updatePlayerList model.players
  in
    { model | players = updatedPlayers }

parseLevel : String -> Int
parseLevel levelStr =
  Result.withDefault 0 (String.toInt levelStr)
