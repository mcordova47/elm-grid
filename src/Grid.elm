module Grid exposing (view)

import Html exposing (Html)
import Html.Attributes as Attributes


type alias Props msg =
    { cellRenderer : Int -> Int -> Html msg
    , rowCount : Int
    , columnCount : Int
    }


view : Props msg -> Html msg
view props =
    Html.div
        [ Attributes.style
            [ ( "display", "grid" )
            , ( "grid-template-columns", gridTemplate props.columnCount )
            , ( "grid-template-rows", gridTemplate props.rowCount )
            ]
        ]
        (List.concat (renderBody props))


renderBody : Props msg -> List (List (Html msg))
renderBody props =
    List.map
        (renderRow props)
        (List.range 0 (props.rowCount - 1))


renderRow : Props msg -> Int -> List (Html msg)
renderRow props row =
    List.map
        (cellRenderer props row)
        (List.range 0 (props.columnCount - 1))


cellRenderer : Props msg -> Int -> Int -> Html msg
cellRenderer props row column =
    Html.div []
        [ props.cellRenderer row column ]


gridTemplate : Int -> String
gridTemplate count =
    String.join " " <|
        (List.map (\_ -> "1fr") (List.range 1 count))
