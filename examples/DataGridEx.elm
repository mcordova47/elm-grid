module BasicGrid exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
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
    = ToggleChecked Int


type alias Model =
    { data : List Person
    }


type alias Person =
    { firstName : String
    , lastName : String
    , age : Int
    , checked : Bool
    , id : Int
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
        ToggleChecked index ->
            { model | data = toggleChecked index model.data }


toggleChecked : Int -> List Person -> List Person
toggleChecked index people =
    List.map
        (\person ->
            if person.id == index then
                { person | checked = not person.checked }
            else
                person
        )
        people


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
                [ { template = checkboxCell
                  , header = header ""
                  , width = "25px"
                  }
                , { template = Html.text << .firstName
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


checkboxCell : Person -> Html Msg
checkboxCell person =
    Html.div
        [ Events.onClick (ToggleChecked person.id)
        , Attributes.style (checkboxStyle person.checked)
        ]
        []


headerStyle : List ( String, String )
headerStyle =
    [ ( "color", "#adadad" )
    , ( "font-size", "14px" )
    ]


bodyStyle : List ( String, String )
bodyStyle =
    [ ( "padding", "20px" )
    ]


checkboxStyle : Bool -> List ( String, String )
checkboxStyle checked =
    let
        bgColor =
            if checked then
                "black"
            else
                ""
    in
        [ ( "border", "1px solid black" )
        , ( "background-color", bgColor )
        , ( "width", "15px" )
        , ( "height", "15px" )
        , ( "cursor", "pointer" )
        , ( "border-radius", "3px" )
        ]


beatle : Int -> Person
beatle n =
    case n % 4 of
        0 ->
            Person "John" "Lennon" 77 False n

        1 ->
            Person "Paul" "McCartney" 75 False n

        2 ->
            Person "George" "Harrison" 77 False n

        _ ->
            Person "Ringo" "Starr" 74 False n
