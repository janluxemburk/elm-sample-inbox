module Inbox.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (..)
import Msg exposing (..)
import Types exposing (..)
import Utils exposing (dateToString, filterEmailsByInboxCategory, sortEmailsByDate)


view : Model -> Html Msg
view model =
    div [ class "inbox" ]
        [ viewInboxTopbar model
        , div [ class "inbox__layout-container" ]
            [ viewEmailList model
            , viewEmailView model.inbox.selectedEmail
            ]
        ]


viewEmailList : Model -> Html Msg
viewEmailList model =
    let
        filteredEmails =
            filterEmailsByInboxCategory model.inbox.selectedEmailCategory model.inbox.emails

        sortedEmails =
            sortEmailsByDate filteredEmails

        listItem =
            \email ->
                let
                    selected =
                        case model.inbox.selectedEmail of
                            Just anEmail ->
                                anEmail == email

                            Nothing ->
                                False

                    unread =
                        email.emailType == Received Unread
                in
                    div
                        [ classList
                            [ ( "inbox__email-listitem", True )
                            , ( "active", selected )
                            , ( "unread", unread )
                            ]
                        , onClick <| SelectEmail email
                        ]
                        [ div [ class "email-listitem__headline" ]
                            [ span [ class "email-listitem__subject text-ellipse" ] [ text email.subject ]
                            , div [ class "email-listitem__meta" ] [ text <| dateToString email.date ]
                            ]
                        , span [ class "email-listitem__sender text-ellipse" ] [ text email.from.name ]
                        ]
    in
        section [ class "inbox__email-list" ] <|
            List.map listItem sortedEmails


viewEmailView : Maybe Email -> Html Msg
viewEmailView anEmail =
    case anEmail of
        Nothing ->
            section [ class "inbox__email-view" ]
                [ Html.text ""
                ]

        Just email ->
            section [ class "inbox__email-view" ]
                [ header [ class "email-header" ] [ h1 [] [ text email.subject ] ]
                , article [ class "email" ]
                    [ div [ class "email-summary" ]
                        [ div [ class "summary-summary" ]
                            [ span [ class "text-ellipse" ]
                                [ span [] [ text <| "From: " ++ email.from.name ]
                                , em [] [ text <| "<" ++ email.from.email ++ ">" ]
                                ]
                            , span [ class "summary-date" ] [ text <| dateToString email.date ]
                            ]
                        , div []
                            [ span [ class "text-ellipse" ]
                                [ span [] [ text <| "To: " ++ email.recipient.name ]
                                , em [] [ text <| "<" ++ email.recipient.email ++ ">" ]
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
                    , div [ class "email-body" ] [ text email.body ]
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
