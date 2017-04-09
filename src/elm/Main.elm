module Main exposing (..)

import Html exposing (program)
import Model exposing (Model, initialModel)
import Update exposing (update)
import Msg exposing (Msg(..))
import View exposing (view)
import Time exposing (Time, minute)
import Task


init : ( Model, Cmd Msg )
init =
    ( initialModel, Task.perform Tick Time.now )


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
    Time.every minute Tick
