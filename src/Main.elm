import Html exposing (..)

main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL

type alias Model = String

init : (Model, Cmd Msg)
init = 
    ("Hello World", Cmd.none)

-- UPDATE

type Msg
    = NoOp

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = 
    Sub.none

-- VIEW

view : Model -> Html Msg
view model =
    div [] [ text model ]