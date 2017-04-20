module Tests exposing (..)

import Test exposing (..)
import Expect
import Utils exposing (..)
import Model exposing (initialModel, Model)
import Update exposing (update)
import Msg exposing (..)
import TestUtil exposing (testEmail)
import Date
import Compose exposing (composeEmailTests, composeEmailInputsTests)
import EmailList exposing (selectEmailTests, markEmailAsUnreadTest)


all : Test
all =
    describe ""
        [ helperFunctionsTests
        , initialModelTests
        , composeEmailTests
        , composeEmailInputsTests
        , selectEmailTests
        , markEmailAsUnreadTest
        , replyEmailTests
        ]


initialModelTests : Test
initialModelTests =
    describe "model"
        [ test "should initially have closed modal for composing email" <|
            \() ->
                initialModel.composedEmail
                    |> Expect.equal Nothing
        , test "should initially have empty search string" <|
            \() ->
                initialModel.searchString
                    |> Expect.equal Nothing
        ]


helperFunctionsTests : Test
helperFunctionsTests =
    describe "tests of helper functions:"
        [ test "dateToString should convert known Date to String" <|
            \() ->
                let
                    date =
                        Date.fromTime (1491161986 * 1000)

                    dateString =
                        dateToString date
                in
                    Expect.equal "2/Apr/2017" dateString
        ]


replyEmailTests : Test
replyEmailTests =
    describe "replying to email"
        [ test "should open compose modal" <|
            \() ->
                initialModel
                    |> update (ReplyEmail testEmail)
                    |> Tuple.first
                    |> .composedEmail
                    |> Expect.notEqual Nothing
        , test "should prefill subject and recipient" <|
            \() ->
                let
                    composedEmail =
                        initialModel
                            |> update (ReplyEmail testEmail)
                            |> Tuple.first
                            |> .composedEmail
                in
                    case composedEmail of
                        Nothing ->
                            Expect.fail "No email is being composed"

                        Just email ->
                            Expect.all
                                [ \email -> Expect.equal "Re: testmail" email.subject
                                , \email -> Expect.equal "test@contact.com" email.recipient.email
                                ]
                                email
        ]
