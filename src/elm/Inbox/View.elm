module Inbox.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Types exposing (..)
import Utils exposing (dateToString)


view : Model -> Html Msg
view model =
    div [ class "inbox" ]
        [ viewInboxTopbar model
        , div [ class "inbox__layout-container" ]
            [ viewEmailList model.inbox.emails
            , viewEmailView model.inbox.selectedEmail
            ]
        ]


viewIconButton : String -> Html Msg
viewIconButton iconClass =
    button [ class "tool-button", type_ "button" ]
        [ i [ class <| "fa " ++ iconClass ] [] ]


viewInboxTopbar : Model -> Html Msg
viewInboxTopbar model =
    div [ class "inbox__topbar" ]
        [ div [ class "inbox__topbar__toolbar" ]
            [ div [ class "button-container toolbar__readunread" ]
                [ viewIconButton "fa-eye"
                , viewIconButton "fa-eye-slash"
                ]
            , div [ class "button-container toolbar__moveto" ]
                [ viewIconButton "fa-trash-o"
                , viewIconButton "fa-archive"
                , viewIconButton "fa-ban"
                ]
            ]
        , div [ class "inbox__topbar__paginator" ] []
        ]


viewEmailListItem : Email -> Html Msg
viewEmailListItem email =
    div [ class "inbox__email-listitem" ]
        [ div [ class "email-listitem__headline" ]
            [ span [ class "email-listitem__subject text-ellipse" ] [ text email.message.subject ]
            , div [ class "email-listitem__meta" ] [ text <| dateToString email.message.date ]
            ]
        , div [ class "email-listitemm__from" ]
            [ span [ class "email-listitem__sender" ] [ text email.message.from.name ] ]
        ]


viewEmailList : List Email -> Html Msg
viewEmailList emails =
    section [ class "inbox__email-list" ]
        (List.map viewEmailListItem emails)


viewEmailView : Email -> Html Msg
viewEmailView email =
    section [ class "inbox__email-view" ]
        [ header [ class "email-header" ] [ h1 [] [ text email.message.subject ] ]
        , article [ class "email" ]
            [ div [ class "email-summary" ]
                [ div [ class "summary-summary" ]
                    [ span [ class "text-ellipse" ]
                        [ span [] [ text <| "From: " ++ email.message.from.name ]
                        , em [] [ text <| "<" ++ email.message.from.email ++ ">" ]
                        ]
                    , span [ class "summary-date" ] [ text <| dateToString email.message.date ]
                    ]
                , div []
                    [ span [ class "text-ellipse" ]
                        [ span [] [ text <| "To: " ++ email.message.to.name ]
                        , em [] [ text <| "<" ++ email.message.to.email ++ ">" ]
                        ]
                    ]
                , div [ class "summary-tools" ]
                    [ div [ class "button-container sumarry-tools__reply" ]
                        [ viewIconButton "fa-reply"
                        , viewIconButton "fa-reply-all"
                        , viewIconButton "fa-share"
                        ]
                    ]
                ]
            , div [ class "email-body" ] [ text email.message.body ]
            ]
        ]
