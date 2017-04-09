module Model exposing (..)

import Types exposing (..)
import SampleData.Emails exposing (sampleEmails)
import Dict exposing (Dict)
import Time exposing (Time)


type alias Model =
    { inbox : InboxModel
    , loggedUser : User
    , searchString : Maybe String
    , composedEmail : Maybe Email
    , currentTime : Time
    }


type alias InboxModel =
    { emails : Dict Int Email
    , selectedEmail : Maybe Email
    , selectedEmailCategory : InboxEmailCategory
    }


initialModel : Model
initialModel =
    { inbox = initialInboxModel
    , loggedUser = User "Brice Anxo" "brice.anki@elm-lang.com"
    , searchString = Nothing
    , composedEmail = Nothing
    , currentTime = 0
    }


initialInboxModel : InboxModel
initialInboxModel =
    { emails = sampleEmails
    , selectedEmail = Nothing
    , selectedEmailCategory = Inbox
    }
