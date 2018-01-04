module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Msgs exposing (Msg)
import Models exposing (Player)
import RemoteData exposing (WebData)
import Routing exposing (playerPath, createPlayerPath)

view : WebData (List Player) -> Html Msg
view response =
  div []
    [ nav
    , maybeList response ]

nav : Html Msg
nav =
  div [ class "flex mb2 white bg-black items-center" ]
    [ div [ class "flex-auto m1 h1 ml2" ] [text "Players"]
    , a [ class "btn regular m1", href createPlayerPath ]
        [ i [ class "fa fa-plus-square-o fa-2x" ] [] ]
    ]

maybeList : WebData (List Player) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success players ->
            list players

        RemoteData.Failure error ->
            text (toString error)

list : List Player -> Html Msg
list players =
  div [ class "p2" ]
    [ table []
        [ thead []
            [ tr []
                [ th [] [text "Id"]
                , th [] [text "Name"]
                , th [] [text "Level"]
                , th [] [text "Actions"]
                ]
            ]
        , tbody [] (List.map playerRow players)
        ]
    ]

playerRow : Player -> Html Msg
playerRow player =
  tr []
    [ td [] [ text player.id ]
    , td [] [ text player.name ]
    , td [] [ text (toString player.level) ]
    , td [] [ editButton player, deleteButton player ]
    ]

editButton : Player -> Html Msg
editButton player =
  let
    path = playerPath player.id
  in
    a [ class "btn regular", href path ]
      [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]

deleteButton : Player -> Html Msg
deleteButton player =
  let
    message = Msgs.OnDeletePlayer player.id
  in
    a [ class "btn regular", onClick message ]
      [ i [ class "fa fa-trash mr1" ] [], text "Delete" ]
