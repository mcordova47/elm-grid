module DataGrid exposing (view)

import Grid
import Html exposing (Html)


type alias Column a msg =
    { template : a -> Html msg
    , header : Html msg
    }


type alias Props a msg =
    { data : List a
    , columns : List (Column a msg)
    }


view : Props a msg -> Html msg
view props =
    Grid.view
        { cellRenderer =
            cellRenderer props
        , rowCount =
            (List.length props.data) + 1
        , columnCount =
            List.length props.columns
        }


cellRenderer : Props a msg -> Int -> Int -> Html msg
cellRenderer props row col =
    if row == 0 then
        headerRenderer props col
    else
        bodyRenderer props row col


headerRenderer : Props a msg -> Int -> Html msg
headerRenderer props col =
    props.columns
        |> get col
        |> Maybe.map .header
        |> Maybe.withDefault (Html.text "")


bodyRenderer : Props a msg -> Int -> Int -> Html msg
bodyRenderer props row col =
    let
        template =
            props.columns
                |> get col
                |> Maybe.map .template
                |> Maybe.withDefault (\a -> Html.text "")
    in
        props.data
            |> get (row - 1)
            |> Maybe.map template
            |> Maybe.withDefault (Html.text "")


get : Int -> List a -> Maybe a
get index list =
    list
        |> List.indexedMap (\i v -> ( i, v ))
        |> List.filter (\( i, v ) -> i == index)
        |> List.head
        |> Maybe.map (\( i, v ) -> v)
