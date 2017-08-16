module UI.Input
    exposing
        ( theme
        , ThemeCssClasses(..)
        , InputTypes(..)
        , InputModel
        , view
        )

import Html exposing (..)
import Html.Attributes as Attr
import Html.CssHelpers exposing (Namespace, withNamespace)
import Html.Events exposing (onInput, on, keyCode)
import Css exposing (..)
import Json.Decode as Json


{-|
-}
styles : List Mixin -> Html.Attribute msg
styles =
    asPairs >> Attr.style


{-| theme

Isolates theme related styles from other css definitions

-}
theme : Namespace String a b c
theme =
    withNamespace "AsheWorks--Elm-UI--Input--"


{-| ThemeCssClasses

-}
type ThemeCssClasses
    = Theme_Input
    | Theme_Input_Error


{-| InputTypes
-}
type InputTypes
    = TextField
    | PasswordField


{-| InputModel

State for an input text box with placeholder and validation highlighting

-}
type alias InputModel command =
    { id : String
    , placeholder : String
    , inputType : InputTypes
    , value : String
    , error : Bool
    , onInput : String -> command
    , onKeyDown : Int -> command
    }


{-| inputType
-}
inputType : InputTypes -> Attribute msg
inputType value =
    case value of
        TextField ->
            Attr.type_ "text"

        PasswordField ->
            Attr.type_ "password"


{-| view

-}
view : InputModel command -> Html command
view model =
    input
        [ Attr.id <| model.id
        , styles <|
            [ padding2 (px 5) (px 10)
            , margin2 (px 0) (px 10)
            , marginBottom (px 10)
            , fontSize (Css.em 1.1)
            , borderRadius (px 4)
            , border3 (px 1) solid (hex "#BBB")
            ]
                ++ if model.error then
                    [ outline3 (px 1) solid (hex "#f00")
                    ]
                   else
                    []
        , theme.class <|
            [ Theme_Input
            ]
                ++ if model.error then
                    [ Theme_Input_Error
                    ]
                   else
                    []
        , Attr.placeholder model.placeholder
        , inputType model.inputType
        , Attr.defaultValue model.value
        , Attr.value model.value
        , onInput <| model.onInput
        , on "keyDown" <| (Json.map model.onKeyDown keyCode)
        ]
        []
