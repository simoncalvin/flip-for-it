port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dom exposing (..)
import Task exposing (..)


-- MODEL


type alias Model =
    { input : String
    , player : Maybe String
    , opponent : Maybe String
    , token : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" Nothing Nothing "", attempt (always NoOp) <| focus "tag" )



-- VIEW


view : Model -> Html Msg
view model =
    let
        form prompt confirmation set =
            Html.form [ onSubmit set ]
                [ label [ for "tag" ] [ text prompt ]
                , input [ type_ "text", id "tag", onInput Input ] []
                , input [ type_ "submit", value confirmation ] []
                ]
    in
        case model.player of
            Just player ->
                div []
                    [ p []
                        ([ text <| "Hi, " ++ player ]
                            ++ case model.opponent of
                                Just opponent ->
                                    [ p [] [ text <| "OK. Let's let " ++ opponent ++ " know" ]
                                    , p []
                                        [ label [ for "tag" ] [ text <| "Give him/her this:" ]
                                        , input [ type_ "text", id "tag", value model.token, onInput Input ] []
                                        , input [ type_ "button", value "📋", onClick Copy ] []
                                        ]
                                    ]

                                Nothing ->
                                    [ form "Who do you want to flip?" "OK" Opponent ]
                        )
                    ]

            Nothing ->
                form "What's your name?" "OK" Player



-- UPDATE


type Msg
    = Input String
    | Player
    | Opponent
    | Copy
    | NoOp


port copy : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input value ->
            ( { model | input = value }, Cmd.none )

        Player ->
            ( { model | input = "", player = Just model.input }, attempt (always NoOp) <| focus "tag" )

        Opponent ->
            ( { model
                | input = ""
                , opponent = Just model.input
                , token = "token"
              }
            , Cmd.none
            )

        Copy ->
            ( model, copy model.token )

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
