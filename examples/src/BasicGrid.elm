module BasicGrid exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes
import Grid exposing (defaultProps)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }


type Msg
    = NoOp


type alias Model =
    { data : List (List String)
    }


init : Model
init =
    { data =
        [ [ "a", "b", "c" ]
        , [ "d", "e", "f" ]
        , [ "g", "h", "i" ]
        , [ "j", "k", "l" ]
        ]
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


view : Model -> Html Msg
view model =
    Html.div
        [ Attributes.style
            [ ( "width", "300px" ) ]
        ]
        [ Grid.view
            { defaultProps
                | cellRenderer =
                    cellRenderer model.data
                , rowCount =
                    List.length model.data
                , columnCount =
                    model.data
                        |> get 0
                        |> Maybe.withDefault []
                        |> List.length
                , width = "300px"
            }
        ]


cellRenderer : List (List String) -> Int -> Int -> Html msg
cellRenderer data row col =
    data
        |> get row
        |> Maybe.withDefault []
        |> get col
        |> Maybe.withDefault ""
        |> Html.text


get : Int -> List a -> Maybe a
get index list =
    list
        |> List.indexedMap (\i v -> ( i, v ))
        |> List.filter (\( i, v ) -> i == index)
        |> List.head
        |> Maybe.map (\( i, v ) -> v)
