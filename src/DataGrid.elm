module DataGrid exposing (view, defaultProps)

import Grid
import Html exposing (Html)


type alias Column a msg =
    { template : a -> Html msg
    , header : Html msg
    , width : String
    }


type alias Props a msg =
    { data : List a
    , columns : List (Column a msg)
    , height : Maybe Int
    , width : String
    , rowHeight : Int
    }


defaultProps : Props a msg
defaultProps =
    { data = []
    , columns = []
    , height = Nothing
    , width = ""
    , rowHeight = 20
    }


view : Props a msg -> Html msg
view props =
    Html.div []
        [ Grid.view
            { cellRenderer = headerRenderer props
            , columnMeasurer = columnMeasurer (addExtraColumn props props.columns)
            , rowCount = 1
            , columnCount = headerCount props
            , height = (toString props.rowHeight) ++ "px"
            , width = ""
            }
        , Grid.view
            { cellRenderer = cellRenderer props
            , columnMeasurer = columnMeasurer props.columns
            , rowCount = List.length props.data
            , columnCount = List.length props.columns
            , height = gridHeight props.height
            , width = props.width
            }
        ]


gridHeight : Maybe Int -> String
gridHeight height =
    height
        |> Maybe.map (\h -> (toString h) ++ "px")
        |> Maybe.withDefault ""


headerRenderer : Props a msg -> Int -> Int -> Html msg
headerRenderer props _ col =
    props.columns
        |> addExtraColumn props
        |> get col
        |> Maybe.map .header
        |> Maybe.withDefault (Html.text "")


cellRenderer : Props a msg -> Int -> Int -> Html msg
cellRenderer props row col =
    let
        template =
            props.columns
                |> get col
                |> Maybe.map .template
                |> Maybe.withDefault (\a -> Html.text "")
    in
        props.data
            |> get row
            |> Maybe.map template
            |> Maybe.withDefault (Html.text "")


columnMeasurer : List (Column a msg) -> Int -> String
columnMeasurer columns index =
    columns
        |> List.map .width
        |> get index
        |> Maybe.withDefault "1fr"


hasScrollbar : Props a msg -> Bool
hasScrollbar props =
    props.height
        |> Maybe.map (\h -> h < props.rowHeight * (List.length props.data))
        |> Maybe.withDefault False


addExtraColumn : Props a msg -> List (Column a msg) -> List (Column a msg)
addExtraColumn props cols =
    if hasScrollbar props then
        cols
            ++ [ { template = \_ -> Html.text ""
                 , header = Html.text ""
                 , width = "17px"
                 }
               ]
    else
        cols


headerCount : Props a msg -> Int
headerCount props =
    if hasScrollbar props then
        (List.length props.columns) + 1
    else
        List.length props.columns


get : Int -> List a -> Maybe a
get index list =
    list
        |> List.indexedMap (\i v -> ( i, v ))
        |> List.filter (\( i, v ) -> i == index)
        |> List.head
        |> Maybe.map (\( i, v ) -> v)
