module View exposing (view)

import Models exposing (Model)
import Update exposing (Msg)
import Html exposing (Html, div, text, p, img, i, span, button, input)
import Html.Attributes exposing (class, src)


viewSidebarItem : String -> Html Msg
viewSidebarItem item =
    div [ class "sidebar-item" ]
        [ i [] []
        , span [] [ text item ]
        ]


viewSidebar : Model -> Html Msg
viewSidebar model =
    div [ class "sidebar" ] <|
        button [] [ text "Compose" ]
            :: List.map viewSidebarItem model.sidebarItems


viewTopbar : Model -> Html Msg
viewTopbar model =
    div [ class "topbar" ]
        [ div [ class "topbar__logo" ]
            [ img [ src "assets/logo.svg", class "topbar__logo-img" ] [] ]
        , div
            [ class "topbar__container" ]
            [ div [ class "topbar__search" ] [ input [] [] ]
            , div [ class "topbar__login" ] [ span [] [ text "Login" ] ]
            ]
        ]


viewInbox : Model -> Html Msg
viewInbox model =
    div [ class "inbox" ]
        [ div [ class "inbox__email-list" ] []
        , div [ class "inbox__current-email" ] []
        ]


view : Model -> Html Msg
view model =
    div [ class "app-container" ]
        [ viewTopbar model
        , div [ class "content-container" ]
            [ viewSidebar model
            , viewInbox model
            ]
        ]
