module View exposing (view)

import Model exposing (Model)
import Msg exposing (NavigationMsg(..), Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Inbox.View


view : Model -> Html Msg
view model =
    div [ class "app-container" ]
        [ viewTopbar model
        , div [ class "content-container" ]
            [ viewSidebar model
            , Inbox.View.view model
            ]
        , composeModal model
        ]


composeModal : Model -> Html Msg
composeModal modal =
    div [ class "compose-modal" ]
        [ header [ class "compose-modal__header" ]
            [ span [ class "compose-modal__header-title" ] [ text "New Message" ]
            , div [ class "compose-modal__header-actions" ]
                [ button [ class "compose-modal__header-button" ]
                    [ i [ class "fa fa-times" ] []
                    ]
                ]
            ]
        , Html.form [ class "compose-form" ]
            [ div [ class "compose-form__row compose-form__from" ]
                [ label [] [ text "From" ]
                , input [ type_ "text" ] []
                ]
            , div [ class "compose-form__row compose-form__to" ]
                [ label [] [ text "To" ]
                , input [ type_ "text" ] []
                ]
            , div [ class "compose-form__row compose-form__subject" ]
                [ input [ type_ "text", placeholder "Subject" ] []
                ]
            , div [ class "compose-form__body" ]
                [ textarea [] [] ]
            ]
        , footer [ class "compose-modal__footer" ]
            [ button [ class "compose-modal__send-button" ]
                [ span [] [ text "Send" ]
                ]
            ]
        ]


type alias NavigationItem =
    ( String, String, NavigationMsg )


sideNavigation : List NavigationItem
sideNavigation =
    [ ( "Inbox", "fa-inbox", Inbox )
    , ( "Draft", "fa-file", Drafts )
    , ( "Sent", "fa-send", Sent )
    , ( "Starred", "fa-star-o", Starred )
    , ( "Archive", "fa-archive", Archive )
    , ( "Spam", "fa-ban", Spam )
    ]


viewSidebar : Model -> Html Msg
viewSidebar model =
    section [ class "sidebar" ]
        [ button [ class "sidebar__compose-button", type_ "button" ] [ i [ class "fa fa-pencil" ] [], span [] [ text "Compose" ] ]
        , ul [ class "sidebar__navigation" ] <|
            List.map sidebarNavigatonItem sideNavigation
        ]


sidebarNavigatonItem : NavigationItem -> Html Msg
sidebarNavigatonItem ( name, icon, msg ) =
    li [ class "sidebar__navigation-item" ]
        [ i [ class <| "fa " ++ icon ] []
        , span [] [ text name ]
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
