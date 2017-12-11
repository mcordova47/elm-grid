module Grid exposing (view, defaultProps)

import Html exposing (Html)
import Html.Attributes as Attributes


type alias Props msg =
    { cellRenderer : Int -> Int -> Html msg
    , columnMeasurer : Int -> String
    , rowCount : Int
    , columnCount : Int
    , height : String
    , width : String
    }


defaultProps : Props msg
defaultProps =
    { cellRenderer = \_ _ -> Html.text ""
    , columnMeasurer = \_ -> "1fr"
    , rowCount = 0
    , columnCount = 0
    , height = ""
    , width = ""
    }


view : Props msg -> Html msg
view props =
    Html.div
        [ Attributes.style
            [ ( "display", "grid" )
            , ( "grid-template-columns", gridTemplateColumns props )
            , ( "grid-template-rows", gridTemplate props.rowCount )
            , ( "height", props.height )
            , ( "overflow", "auto" )
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


gridTemplateColumns : Props msg -> String
gridTemplateColumns props =
    String.join " "
        (List.map props.columnMeasurer (List.range 0 (props.columnCount - 1)))


gridTemplate : Int -> String
gridTemplate count =
    String.join " "
        (List.map (\_ -> "1fr") (List.range 1 count))
