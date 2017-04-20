module TestUtil exposing (..)

import Types exposing (..)
import Date


testEmail : Email
testEmail =
    let
        from =
            Contact "test contact" "test@contact.com"

        recipient =
            Contact "" ""
    in
        Email
            999999
            (Date.fromTime 0)
            Draft
            False
            []
            Nothing
            from
            recipient
            "testmail"
            ""
