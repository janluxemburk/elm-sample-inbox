module Types exposing (..)

import Date exposing (Date)


type alias Email =
    { emailId : Int
    , date : Date
    , emailType : EmailType
    , starred : Bool
    , labels : List String
    , from : Contact
    , recipient : Contact
    , subject : String
    , body : String
    }


type EmailType
    = Received EmailReadStatus
    | IsSent
    | Draft -- add type "being composed"


type EmailReadStatus
    = Unread
    | Read


type alias Contact =
    { name : String
    , email : String
    }


type alias User =
    { name : String
    , email : String
    }


type InboxEmailCategory
    = Inbox
    | Drafts
    | Sent
    | Starred
    | Archive
    | Spam
    | Trash


type alias NavigationItem =
    ( String, String, InboxEmailCategory )
