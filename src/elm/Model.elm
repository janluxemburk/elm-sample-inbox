module Model exposing (..)

import Types exposing (..)
import Date


type alias Model =
    { inbox : InboxModel
    , title : String
    }


type alias InboxModel =
    { emails : List Email
    , selectedEmail : Email
    }


initialModel : Model
initialModel =
    { title = "Inbox"
    , inbox = initialInboxModel
    }


initialInboxModel : InboxModel
initialInboxModel =
    { emails = sampleEmails
    , selectedEmail = sampleEmail
    }


sampleEmails : List Email
sampleEmails =
    List.repeat 5 sampleEmail


sampleEmail : Email
sampleEmail =
    let
        from =
            Contact "Jan Luxemburk" "jan.luxemburk@protonmail.com"

        to =
            Contact "Robert Pergl" "robert.pergls@fit.cvut.cz"

        anMessage =
            EmailMessage from
                to
                (Date.fromTime 0)
                "A subject"
                """Hello,
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."""
    in
        Email (Received Read) (EmailMetaInformation False []) anMessage
