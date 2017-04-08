module Types exposing (..)

import Date exposing (Date)


type alias Email =
    { emailType : EmailType
    , metaInformation : EmailMetaInformation
    , message : EmailMessage
    }


type EmailReadStatus
    = Unread
    | Read


type EmailType
    = Received EmailReadStatus
    | Sent
    | Draft


type alias Contact =
    { name : String
    , email : String
    }


type alias EmailMetaInformation =
    { starred : Bool
    , labels : List String
    }


type alias EmailMessage =
    { from : Contact
    , to : Contact
    , date : Date
    , subject : String
    , body : String
    }
