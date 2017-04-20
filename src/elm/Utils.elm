module Utils exposing (..)

import Date exposing (Date)
import Model exposing (Model)
import Types exposing (..)
import Dict exposing (Dict)
import Date.Extra


dateToString : Date -> String
dateToString date =
    let
        day =
            Date.day date

        month =
            Date.month date

        year =
            Date.year date
    in
        toString day ++ "/" ++ toString month ++ "/" ++ toString year


createEmail : Model -> Email
createEmail model =
    let
        id =
            Dict.size model.inbox.emails + 1

        from =
            Contact model.loggedUser.name model.loggedUser.email

        recipient =
            Contact "" ""
    in
        Email
            id
            (Date.fromTime model.currentTime)
            Draft
            False
            []
            Nothing
            from
            recipient
            ""
            ""


filterEmailsByInboxCategory : InboxEmailCategory -> Dict Int Email -> List Email
filterEmailsByInboxCategory category emails =
    let
        list =
            Dict.values emails
    in
        case category of
            Inbox ->
                List.filter (\email -> email.folder == Nothing && (email.emailType == Received Read || email.emailType == Received Unread)) list

            Drafts ->
                List.filter (\email -> email.emailType == Draft) list

            Sent ->
                List.filter (\email -> email.folder == Nothing && email.emailType == IsSent) list

            Starred ->
                List.filter (\email -> email.starred == True) list

            Archive ->
                List.filter (\email -> email.folder == Just FolderArchive) list

            Spam ->
                List.filter (\email -> email.folder == Just FolderSpam) list

            Trash ->
                List.filter (\email -> email.folder == Just FolderTrash) list


sortEmailsByDate : List Email -> List Email
sortEmailsByDate emails =
    let
        compareFun =
            (\a b ->
                case Date.Extra.compare a.date b.date of
                    LT ->
                        GT

                    GT ->
                        LT

                    EQ ->
                        EQ
            )
    in
        List.sortWith compareFun emails
