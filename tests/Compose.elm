module Compose exposing (..)

import Dict
import Test exposing (..)
import Fuzz exposing (string)
import Expect
import Model exposing (initialModel, Model)
import Update exposing (update)
import TestUtil exposing (testEmail)
import Msg exposing (..)
import Types exposing (..)


composeEmailTests : Test
composeEmailTests =
    describe "composing email:"
        [ test "compose modal should be opened after ComposeEmail mesage" <|
            \() ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> .composedEmail
                    |> Expect.notEqual Nothing
        , test "compose modal should be closed after Close message" <|
            \() ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> update (ComposeMsg Close)
                    |> Tuple.first
                    |> .composedEmail
                    |> Expect.equal Nothing
        , test "composed email should have author prefilled from logged user" <|
            \() ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> .composedEmail
                    |> (Maybe.withDefault testEmail)
                    |> .from
                    |> .email
                    |> Expect.equal initialModel.loggedUser.email
        , test "compose modal should be closed after saving message as draft" <|
            \() ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> update (ComposeMsg SaveDraft)
                    |> Tuple.first
                    |> .composedEmail
                    |> Expect.equal Nothing
        , test "saving email as a draft should add it to model as draft" <|
            \() ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> update (ComposeMsg SaveDraft)
                    |> Tuple.first
                    |> .inbox
                    |> .emails
                    |> Dict.values
                    |> List.filter (\email -> email.emailType == Draft)
                    |> List.length
                    |> Expect.equal 1
        , test "sending email should add it to model as sent email" <|
            \() ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> update (ComposeMsg Send)
                    |> Tuple.first
                    |> .inbox
                    |> .emails
                    |> Dict.values
                    |> List.filter (\email -> email.emailType == IsSent)
                    |> List.length
                    |> Expect.equal 1
        ]


composeEmailInputsTests : Test
composeEmailInputsTests =
    describe "compose email's"
        [ fuzz string "subject should change according to input" <|
            \randomString ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> update (ComposeMsg (UpdateSubject randomString))
                    |> Tuple.first
                    |> .composedEmail
                    |> (Maybe.withDefault testEmail)
                    |> .subject
                    |> Expect.equal randomString
        , fuzz string "body should change according to input" <|
            \randomString ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> update (ComposeMsg (UpdateBody randomString))
                    |> Tuple.first
                    |> .composedEmail
                    |> (Maybe.withDefault testEmail)
                    |> .body
                    |> Expect.equal randomString
        , fuzz string "recipient should change according to input" <|
            \randomString ->
                initialModel
                    |> update ComposeEmail
                    |> Tuple.first
                    |> update (ComposeMsg (UpdateRecipient randomString))
                    |> Tuple.first
                    |> .composedEmail
                    |> (Maybe.withDefault testEmail)
                    |> .recipient
                    |> .email
                    |> Expect.equal randomString
        ]
