module Models exposing (..)


type alias Model =
    { emails : List String
    , title : String
    , sidebarItems : List String
    }


initialModel : Model
initialModel =
    { emails = []
    , title = "Blog"
    , sidebarItems = [ "Inbox", "Draft", "Sent", "Starred", "Archive", "Spam" ]
    }
