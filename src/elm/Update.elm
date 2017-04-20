module Update exposing (update)

import Model exposing (Model, InboxModel)
import Types exposing (..)
import Msg exposing (..)
import Utils exposing (createEmail)
import Date exposing (Date, now)
import Dict


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectEmail email ->
            selectEmail email model

        SelectInboxEmailCategory inboxEmailCategory ->
            { model | inbox = updateInboxEmailCategory inboxEmailCategory model.inbox } ! []

        ComposeEmail ->
            { model | composedEmail = Just <| createEmail model } ! []

        ComposeMsg msg ->
            updateComposedEmail msg model

        Tick time ->
            { model | currentTime = time } ! []


selectEmail : Email -> Model -> ( Model, Cmd Msg )
selectEmail email model =
    case email.emailType of
        Draft ->
            { model | composedEmail = Just email } ! []

        _ ->
            { model | inbox = updateSelectedEmail email model.inbox } ! []


updateSelectedEmail : Email -> InboxModel -> InboxModel
updateSelectedEmail selectedEmail model =
    let
        selectedId =
            selectedEmail.emailId

        updatedInboxEmails =
            Dict.update selectedId
                (\anEmail ->
                    case anEmail of
                        Nothing ->
                            Nothing

                        Just email ->
                            if email.emailType == Received Unread then
                                Just { email | emailType = Received Read }
                            else
                                Just email
                )
                model.emails

        updatedSelectedEmail =
            Dict.get selectedId updatedInboxEmails
    in
        { model | emails = updatedInboxEmails, selectedEmail = updatedSelectedEmail }


updateInboxEmailCategory : InboxEmailCategory -> InboxModel -> InboxModel
updateInboxEmailCategory category model =
    { model | selectedEmailCategory = category, selectedEmail = Nothing }


updateComposedEmail : ComposeMsg -> Model -> ( Model, Cmd Msg )
updateComposedEmail msg model =
    case model.composedEmail of
        Nothing ->
            model ! []

        Just composedEmail ->
            case msg of
                UpdateRecipient recipient ->
                    { model | composedEmail = Just <| updateEmailRecipient recipient composedEmail } ! []

                UpdateSubject subject ->
                    { model | composedEmail = Just <| updateEmailSubject subject composedEmail } ! []

                UpdateBody body ->
                    { model | composedEmail = Just <| updateEmailBody body composedEmail } ! []

                SaveDraft ->
                    saveDraft composedEmail model ! []

                Close ->
                    { model | composedEmail = Nothing } ! []

                Send ->
                    sendEmail composedEmail model ! []


updateEmailRecipient : String -> Email -> Email
updateEmailRecipient recipient email =
    { email | recipient = Contact "" recipient }


updateEmailSubject : String -> Email -> Email
updateEmailSubject subject email =
    { email | subject = subject }


updateEmailBody : String -> Email -> Email
updateEmailBody body email =
    { email | body = body }


sendEmail : Email -> Model -> Model
sendEmail email model =
    let
        inbox =
            model.inbox

        sentEmail =
            { email | emailType = IsSent, date = Date.fromTime model.currentTime }

        updatedInboxEmails =
            Dict.insert email.emailId sentEmail model.inbox.emails
    in
        { model | composedEmail = Nothing, inbox = { inbox | emails = updatedInboxEmails } }


saveDraft : Email -> Model -> Model
saveDraft email model =
    let
        inbox =
            model.inbox

        draftEmail =
            { email | emailType = Draft, date = Date.fromTime model.currentTime }

        updatedInboxEmails =
            Dict.insert email.emailId draftEmail model.inbox.emails
    in
        { model | composedEmail = Nothing, inbox = { inbox | emails = updatedInboxEmails } }
