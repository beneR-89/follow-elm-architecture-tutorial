module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (PlayerId, Player)
import RemoteData
import Json.Encode as Encode

fetchPlayers : Cmd Msg
fetchPlayers =
  Http.get fetchPlayersUrl playersDecoder
    |> RemoteData.sendRequest
    |> Cmd.map Msgs.OnFetchPlayers

fetchPlayersUrl : String
fetchPlayersUrl =
  "http://localhost:4000/players"

playersDecoder : Decode.Decoder (List Player)
playersDecoder =
  Decode.list playerDecoder

playerDecoder : Decode.Decoder Player
playerDecoder =
  decode Player
    |> required "id" Decode.string
    |> required "name" Decode.string
    |> required "level" Decode.int

savePlayerUrl : PlayerId -> String
savePlayerUrl playerId =
  "http://localhost:4000/players/" ++ playerId

savePlayerRequest : Player -> Http.Request Player
savePlayerRequest player =
  Http.request
    { body = playerEncoder player |> Http.jsonBody
    , expect = Http.expectJson playerDecoder
    , headers = []
    , method = "PATCH"
    , timeout = Nothing
    , url = savePlayerUrl player.id
    , withCredentials = False
    }

savePlayerCmd : Player -> Cmd Msg
savePlayerCmd player =
  savePlayerRequest player
    |> Http.send Msgs.OnPlayerSave

playerEncoder : Player -> Encode.Value
playerEncoder player =
  let
    attributes =
      [ ( "id", Encode.string player.id )
      , ( "name", Encode.string player.name )
      , ( "level", Encode.int player.level )
      ]
  in
    Encode.object attributes

createPlayerRequest : Player -> Http.Request Player
createPlayerRequest player =
  Http.request
    { body = playerEncoder player |> Http.jsonBody
    , expect = Http.expectJson playerDecoder
    , headers = []
    , method = "POST"
    , timeout = Nothing
    , url = "http://localhost:4000/players"
    , withCredentials = False
    }

createPlayerCmd : Player -> Cmd Msg
createPlayerCmd player =
  createPlayerRequest player
    |> Http.send Msgs.OnPlayerCreated

deletePlayerRequest : PlayerId -> Http.Request PlayerId
deletePlayerRequest id =
  Http.request
    { body = Http.emptyBody
    , expect = Http.expectStringResponse (\response -> Ok id)
    , headers = []
    , method = "DELETE"
    , timeout = Nothing
    , url = "http://localhost:4000/players/" ++ id
    , withCredentials = False
    }

deletePlayerCmd : PlayerId -> Cmd Msg
deletePlayerCmd id =
  deletePlayerRequest id
    |> Http.send Msgs.OnPlayerDeleted
