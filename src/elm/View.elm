module View exposing (view)

import Model exposing (Model)
import Msg exposing (..)
import Types exposing (InboxEmailCategory(..), NavigationItem, Email)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Inbox.View


view : Model -> Html Msg
view model =
    div [ class "app-container" ]
        [ viewTopbar model
        , div [ class "content-container" ]
            [ viewSidebar model
            , Inbox.View.view model
            ]
        , viewComposeModal model
        ]


viewComposeModal : Model -> Html Msg
viewComposeModal model =
    case model.composedEmail of
        Just email ->
            composeModal email

        Nothing ->
            Html.text ""


composeModal : Email -> Html Msg
composeModal email =
    div [ class "compose-modal" ]
        [ header [ class "compose-modal__header" ]
            [ span [ class "compose-modal__header-title" ]
                [ text <|
                    if (email.subject == "") then
                        "New Message"
                    else
                        email.subject
                ]
            , div [ class "compose-modal__header-actions" ]
                [ button [ class "compose-modal__header-button", type_ "button", onClick <| ComposeMsg Close ]
                    [ i [ class "fa fa-times" ] []
                    ]
                ]
            ]
        , Html.form [ class "compose-form" ]
            [ div [ class "compose-form__row compose-form__from" ]
                [ label [] [ text "From" ]
                , input [ type_ "text", readonly True, value email.from.email ] []
                ]
            , div [ class "compose-form__row compose-form__to" ]
                [ label [] [ text "To" ]
                , input [ type_ "text", value email.recipient.email, onInput <| ComposeMsg << UpdateRecipient ] []
                ]
            , div [ class "compose-form__row compose-form__subject" ]
                [ input [ type_ "text", placeholder "Subject", value email.subject, onInput <| ComposeMsg << UpdateSubject ] []
                ]
            , div [ class "compose-form__body" ]
                [ textarea [ value email.body, onInput <| ComposeMsg << UpdateBody ] [] ]
            ]
        , footer [ class "compose-modal__footer" ]
            [ button [ class "compose-modal__save-button", type_ "button", title "Save as draft", onClick <| ComposeMsg SaveDraft ]
                [ i [ class "fa fa-floppy-o" ] [] ]
            , button
                [ class "compose-modal__send-button", type_ "button", onClick <| ComposeMsg Send ]
                [ span [] [ text "Send" ]
                ]
            ]
        ]


viewSidebar : Model -> Html Msg
viewSidebar model =
    let
        sidebarNavigation : List NavigationItem
        sidebarNavigation =
            [ ( "Inbox", "fa-inbox", Inbox )
            , ( "Draft", "fa-file", Drafts )
            , ( "Sent", "fa-send", Sent )
            , ( "Starred", "fa-star-o", Starred )
            , ( "Archive", "fa-archive", Archive )
            , ( "Spam", "fa-ban", Spam )
            ]

        sidebarNavigatonItem : NavigationItem -> Html Msg
        sidebarNavigatonItem =
            \( name, icon, category ) ->
                li
                    [ classList
                        [ ( "sidebar__navigation-item", True )
                        , ( "active", model.inbox.selectedEmailCategory == category )
                        ]
                    , onClick <| SelectInboxEmailCategory category
                    ]
                    [ i [ class <| "fa " ++ icon ] []
                    , span [] [ text name ]
                    ]
    in
        section [ class "sidebar" ]
            [ button [ class "sidebar__compose-button", type_ "button", onClick ComposeEmail ]
                [ i [ class "fa fa-pencil" ] [], span [] [ text "Compose" ] ]
            , ul [ class "sidebar__navigation" ] <|
                List.map sidebarNavigatonItem sidebarNavigation
            ]


viewTopbar : Model -> Html Msg
viewTopbar model =
    nav [ class "topbar" ]
        [ div [ class "topbar__logo" ]
            [ img [ src "assets/logo.svg", class "topbar__logo-img" ] [] ]
        , div
            [ class "topbar__menu" ]
            [ div [ class "topbar__search" ]
                [ button [ class "topbar__search-button" ]
                    [ i [ class "fa fa-search" ] [] ]
                , input [ class "topbar__search-input", placeholder "Search" ] []
                ]
            , div [ class "topbar__login" ] [ span [] [ text "" ] ]
            ]
        ]
