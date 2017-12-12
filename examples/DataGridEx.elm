module BasicGrid exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes
import DataGrid
import Grid


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
    { data : List Person
    }


type alias Person =
    { firstName : String
    , lastName : String
    , age : Int
    }


init : Model
init =
    { data =
        List.range 0 999
            |> List.map beatle
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


view : Model -> Html Msg
view model =
    Html.div
        [ Attributes.style bodyStyle ]
        [ DataGrid.view
            { data = model.data
            , height = Just 200
            , width = Just 500
            , rowHeight = 20
            , columns =
                [ { template = Html.text << .firstName
                  , header = header "First Name"
                  , width = "2fr"
                  }
                , { template = Html.text << .lastName
                  , header = header "Last Name"
                  , width = "3fr"
                  }
                , { template = Html.text << toString << .age
                  , header = header "Age"
                  , width = "1fr"
                  }
                ]
            }
        ]


header : String -> Html msg
header title =
    Html.div
        [ Attributes.style headerStyle ]
        [ Html.text title ]


headerStyle : List ( String, String )
headerStyle =
    [ ( "color", "#adadad" )
    , ( "font-size", "14px" )
    ]


bodyStyle : List ( String, String )
bodyStyle =
    [ ( "padding", "20px" )
    ]


beatle : Int -> Person
beatle n =
    case n % 4 of
        0 ->
            Person "John" "Lennon" 77

        1 ->
            Person "Paul" "McCartney" 75

        2 ->
            Person "George" "Harrison" 77

        _ ->
            Person "Ringo" "Starr" 74
