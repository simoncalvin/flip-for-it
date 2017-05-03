port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dom exposing (..)
import Task exposing (..)
import WebSocket


-- MODEL


type alias Model =
    { input : String
    , player : Maybe String
    , opponent : Maybe String
    , call : Maybe Call
    , result : Maybe String
    , canCopyToClipboard : Bool
    }

type Call 
    = Heads
    | Tails

type alias Flags =
    { canCopyToClipboard : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model "" Nothing Nothing Nothing Nothing flags.canCopyToClipboard, attempt (always NoOp) <| focus "tag" )



-- VIEW


view : Model -> Html Msg
view model =
    let
        player next =
            case model.player of
                Just player ->
                    [ p [] [ text <| "Hi, " ++ player ] ] ++ next 
                
                Nothing ->
                    [ Html.form [ onSubmit SetPlayer ]
                        [ label [ for "tag" ] [ text "What's your name?" ]
                        , input [ type_ "text", id "tag", onInput Input, autocomplete False ] []
                        , input [ type_ "submit", value "OK" ] []
                        ]
                    ]
        
        call next =
            case model.call of 
                Just Heads ->
                    [ p [] [ text "You called heads" ] ] ++ next

                Just Tails ->
                    [ p [] [ text "You called tails" ] ] ++ next 

                Nothing ->
                    [ p []
                        [ text <| "OK, call it."
                        , input [ type_ "button", value "Heads", onClick <| MakeCall Heads ] []
                        , input [ type_ "button", value "Tails", onClick <| MakeCall Tails ] []
                        ]
                    ]

        result =
            [ p [] [ text resultText ] ]

        resultText =
            case model.result of 
                Just result ->
                    "It came up " ++ result ++ "!"
                
                Nothing ->
                    "Flipping"
            
        copyOrSelect =
            if model.canCopyToClipboard then
                Copy
            else
                SelectUrl

    in
        div []
            <| player
                <| call 
                <| result
            
                

-- [ text <| "OK. Give this to " ++ opponent ++ ":"
-- , input [ type_ "text", id "url", value model.input, onFocus copyOrSelect, readonly True ] []
-- , input [ type_ "button", value "📋", onClick copyOrSelect ] []
-- ]

-- UPDATE


type Msg
    = Input String
    | SetPlayer
    | MakeCall Call
    | Flipped String
    | SelectUrl   
    | Copy
    | NoOp


port copy : () -> Cmd msg


port selectUrl : () -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        noop =
            ( model, Cmd.none )
    in
        case msg of
            Input value ->
                ( { model | input = value }, Cmd.none )

            SetPlayer ->
                ( { model | input = "", player = Just model.input }
                , focus "tag"
                    |> attempt (always NoOp)
                )

            MakeCall call ->
                ( { model | call = Just call }, WebSocket.send "ws://localhost:1234" <| toString call )

            Flipped result ->
                ( { model | result = Just result }, Cmd.none )

            SelectUrl ->
                ( model, selectUrl () )

            Copy ->
                ( model, Cmd.batch [ selectUrl (), copy () ] )

            NoOp ->
                noop



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://localhost:1234" Flipped



-- MAIN


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
