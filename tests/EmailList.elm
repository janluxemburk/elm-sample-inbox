module EmailList exposing (..)

import Dict
import Test exposing (..)
import Expect
import Model exposing (initialModel, Model)
import Update exposing (update)
import TestUtil exposing (testEmail)
import Msg exposing (..)
import Types exposing (..)


selectEmailTests : Test
selectEmailTests =
    describe "selecting"
        [ test "unread email from list should mark is as read" <|
            \() ->
                let
                    anEmail =
                        Dict.get 1 initialModel.inbox.emails
                in
                    case anEmail of
                        Nothing ->
                            Expect.fail "An email cannot be found in inbox"

                        Just email ->
                            initialModel
                                |> update (SelectEmail email)
                                |> Tuple.first
                                |> .inbox
                                |> .emails
                                |> Dict.get 1
                                |> Maybe.withDefault testEmail
                                |> .emailType
                                |> Expect.equal (Received Read)
        , test "draft email from list should open compose modal" <|
            \() ->
                let
                    modelWithDraft =
                        initialModel
                            |> update ComposeEmail
                            |> Tuple.first
                            |> update (ComposeMsg SaveDraft)
                            |> Tuple.first

                    draftEmail =
                        modelWithDraft
                            |> .inbox
                            |> .emails
                            |> Dict.values
                            |> List.filter (\email -> email.emailType == Draft)
                            |> List.head
                in
                    case draftEmail of
                        Nothing ->
                            Expect.fail "Draft cannot be found in inbox"

                        Just draft ->
                            modelWithDraft
                                |> update (SelectEmail draft)
                                |> Tuple.first
                                |> .composedEmail
                                |> Expect.equal (Just draft)
        ]


markEmailAsUnreadTest : Test
markEmailAsUnreadTest =
    test "marking read email as unread make it unread" <|
        \() ->
            let
                anEmail =
                    Dict.get 1 initialModel.inbox.emails
            in
                case anEmail of
                    Nothing ->
                        Expect.fail "An email cannot be found in inbox"

                    Just email ->
                        let
                            modelWithReadEmail =
                                initialModel
                                    |> update (SelectEmail email)
                                    |> Tuple.first
                        in
                            modelWithReadEmail
                                |> update (MarkEmailAs (EmailReadStatus Unread))
                                |> Tuple.first
                                |> .inbox
                                |> .emails
                                |> Dict.get 1
                                |> Maybe.withDefault testEmail
                                |> .emailType
                                |> Expect.equal (Received Unread)
