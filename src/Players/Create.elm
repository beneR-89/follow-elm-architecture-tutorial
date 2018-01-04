module Players.Create exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (Msg)
import Routing exposing (playersPath)
import Models exposing (Player)

view : Player -> Html Msg
view player =
  div []
    [ nav
    , createPlayerForm player ]

nav : Html Msg
nav =
  div [ class "flex mb2 white bg-black items-center" ]
    [ listButton ]

listButton : Html Msg
listButton =
  a [ class "btn regular m1 h1", href playersPath ]
    [ i [ class "fa fa-chevron-left mr1" ] [], text "List" ]

createPlayerForm : Player -> Html Msg
createPlayerForm player =
  form [ class "flex flex-column p1" ]
    [ createPlayerFormInput "Name" Msgs.OnUpdateFuturePlayerName
    , createPlayerFormInput "Level" Msgs.OnUpdateFuturePlayerLevel
    , createPlayerButton player
    ]

createPlayerButton : Player -> Html Msg
createPlayerButton player =
  button [ class "btn btn-primary", onClick (Msgs.OnCreatePlayer player) ]
    [ text "Create player" ]

createPlayerFormInput : String -> (String -> Msg) -> Html Msg
createPlayerFormInput attrHeader msg =
  label []
    [ text (attrHeader ++ ":")
    , input
        [ class "input"
        , type_ "text"
        , onInput msg ] []
    ]
