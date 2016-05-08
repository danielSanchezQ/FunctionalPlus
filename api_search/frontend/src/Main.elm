module FPlusApiSearch (..) where

import Database exposing (Function, functions)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)
import String


type alias Model =
    { query : String
    }


emptyModel : Model
emptyModel =
    { query = ""
    }


type Action
    = NoOp
    | UpdateQuery String


update : Action -> Model -> Model
update action model =
    case action of
        NoOp ->
            model

        UpdateQuery str ->
            { model | query = str }


view : Address Action -> Model -> Html
view address model =
    div
        [ class "main" ]
        [ input
            [ placeholder "search query"
            , autofocus True
            , style [ ( "width", "500px" ) ]
            , on "input" targetValue (Signal.message address << UpdateQuery)
            ]
            []
        , model.query |> searchFunction |> showFunctions
        ]


searchFunction : String -> List Function
searchFunction query =
    functions


showFunctions : List Function -> Html
showFunctions functions =
    div
        [ class "functions" ]
        (List.map showFunction functions)


singletonList : a -> List a
singletonList x =
    [ x ]



-- todo: display new lines in code, and syntax highlight with highlight.js


stringToCode : String -> Html
stringToCode str =
    str
        |> text
        |> singletonList
        |> code [ style [ ( "display", "block" ) ] ]


showFunction : Function -> Html
showFunction function =
    div
        [ class "function" ]
        [ function.name
            ++ " : "
            ++ function.signature
            |> stringToCode
        , function.documentation |> stringToCode
        , function.declaration |> stringToCode
        ]


main : Signal Html
main =
    Signal.map (view actions.address) model


model : Signal Model
model =
    Signal.foldp update emptyModel actions.signal


actions : Signal.Mailbox Action
actions =
    Signal.mailbox NoOp