module Msg exposing (..)


type Msg
    = NoOp


type NavigationMsg
    = Inbox
    | Drafts
    | Sent
    | Starred
    | Archive
    | Spam
    | Trash
