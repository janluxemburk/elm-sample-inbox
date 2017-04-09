module Msg exposing (..)

import Types exposing (..)
import Date exposing (Date)
import Time exposing (Time)


type Msg
    = SelectEmail Email
    | SelectInboxEmailCategory InboxEmailCategory
    | ComposeEmail
    | ComposeMsg ComposeMsg
    | Tick Time


type ComposeMsg
    = UpdateRecipient String
    | UpdateSubject String
    | UpdateBody String
    | SaveDraft
    | Send
    | Close
