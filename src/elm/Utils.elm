module Utils exposing (..)

import Date exposing (Date)


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
