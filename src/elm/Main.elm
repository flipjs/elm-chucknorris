module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Http
import Task
import Json.Decode as Json


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MODEL


init : ( Model, Cmd Msg )
init =
    ( initialModel, randomJoke )


initialModel : Model
initialModel =
    "Finding a joke..."


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        decoder =
            Json.at [ "value", "joke" ] Json.string

        task =
            Http.get decoder url

        cmd =
            Task.perform Fail Joke task
    in
        cmd


type alias Model =
    String



-- UPDATE


type Msg
    = Joke String
    | Fail Http.Error
    | FetchJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke joke ->
            ( joke, Cmd.none )

        Fail error ->
            ( toString error, Cmd.none )

        FetchJoke ->
            ( model, randomJoke )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchJoke ] [ text "Get random joke" ]
        , hr [] []
        , text model
        ]
