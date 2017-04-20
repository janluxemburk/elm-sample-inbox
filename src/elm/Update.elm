module Update exposing (update)

import Model exposing (Model, InboxModel)
import Types exposing (..)
import Msg exposing (..)
import Utils exposing (createEmail, replyEmail, forwardEmail)
import Date exposing (Date, now)
import Dict


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectEmail email ->
            selectEmail email model

        MarkEmailAs markEmail ->
            { model | inbox = markEmailAs markEmail model.inbox } ! []

        SelectInboxEmailCategory inboxEmailCategory ->
            { model | inbox = updateInboxEmailCategory inboxEmailCategory model.inbox } ! []

        ComposeEmail ->
            { model | composedEmail = Just <| createEmail model } ! []

        ReplyEmail email ->
            { model | composedEmail = Just <| replyEmail model email } ! []

        ForwardEmail email ->
            { model | composedEmail = Just <| forwardEmail model email } ! []

        SearchInput query ->
            { model | searchString = Just query } ! []

        ComposeMsg msg ->
            updateComposedEmail msg model

        Tick time ->
            { model | currentTime = time } ! []


selectEmail : Email -> Model -> ( Model, Cmd Msg )
selectEmail email model =
    case email.emailType of
        Draft ->
            { model | composedEmail = Just email } ! []

        IsSent ->
            { model | inbox = updateSelectedEmail email model.inbox } ! []

        Received Read ->
            { model | inbox = updateSelectedEmail email model.inbox } ! []

        Received Unread ->
            { model | inbox = selectUnreadEmail email model.inbox } ! []


updateSelectedEmail : Email -> InboxModel -> InboxModel
updateSelectedEmail selectedEmail model =
    { model | selectedEmail = Just selectedEmail }


selectUnreadEmail : Email -> InboxModel -> InboxModel
selectUnreadEmail selectedEmail model =
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


markEmailAs : MarkEmail -> InboxModel -> InboxModel
markEmailAs markEmail model =
    case model.selectedEmail of
        Nothing ->
            model

        Just email ->
            case markEmail of
                EmailReadStatus readStatus ->
                    let
                        selectedId =
                            email.emailId

                        updatedInboxEmails =
                            Dict.update selectedId
                                (\anEmail ->
                                    case anEmail of
                                        Nothing ->
                                            Nothing

                                        Just email ->
                                            if email.emailType == Received Unread || email.emailType == Received Read then
                                                Just { email | emailType = Received readStatus }
                                            else
                                                Just email
                                )
                                model.emails

                        updatedSelectedEmail =
                            Dict.get selectedId updatedInboxEmails
                    in
                        { model | emails = updatedInboxEmails, selectedEmail = updatedSelectedEmail }

                Folder folder ->
                    let
                        selectedId =
                            email.emailId

                        updatedInboxEmails =
                            Dict.update selectedId
                                (\anEmail ->
                                    case anEmail of
                                        Nothing ->
                                            Nothing

                                        Just email ->
                                            Just { email | folder = Just folder }
                                )
                                model.emails

                        updatedSelectedEmail =
                            Dict.get selectedId updatedInboxEmails
                    in
                        { model | emails = updatedInboxEmails, selectedEmail = updatedSelectedEmail }
