module Main exposing (..)

import Html exposing (program)
import Model exposing (Model, initialModel)
import Update exposing (update)
import Msg exposing (Msg)
import View exposing (view)


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
