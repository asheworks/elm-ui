module UI exposing
  ( ThemeCssClasses(..)
  , Theme
  , theme
  , InputTypes(..)
  , InputModel
  , LabelModel
  , styles
  , flexColumn
  , flexRow
  , errorLabel
  , inputField
  , labelField
  )

{-| This library contains common UI control definitions

## Style Definitions
@docs theme, ThemeCssClasses, Theme

## Form Element Types
@docs InputModel, InputTypes, LabelModel

@docs styles, flexColumn, flexRow

@docs inputField, labelField, errorLabel

-}

--
-- Semantic Forms:
-- https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Forms/How_to_structure_an_HTML_form
--

import Html exposing (..)
import Html.Attributes exposing (defaultValue, for, id, placeholder, required, style, type_, value)
import Html.CssHelpers exposing (Namespace, withNamespace)
import Html.Events exposing (onInput, onClick)
import Css exposing (..)

--

{-| namespace

Isolates theme related styles from other css definitions

-}
theme : Namespace String a b c
theme =
    withNamespace "AshwWorks--Elm-UI--Theme--"

{-| ThemeCssClasses
-}
type ThemeCssClasses
    = Theme_InputField
    | Theme_InputField_Label
    | Theme_InputField_Input
    | Theme_InputField_InputError
    | Theme_InputField_Error
    | Theme_LabelField
    | Theme_LabelField_Label
    | Theme_LabelField_Value
    | Theme_FormError

{-| Theme

-}
type alias Theme b command = Namespace String ThemeCssClasses b command

{-| InputTypes
-}
type InputTypes
    = TextField
    | PasswordField

{-| InputModel

State for an input text box with placeholder and validation labels

-}
type alias InputModel command =
    { key : String
    , label : String
    , placeholder : String
    , inputType : InputTypes
    , value : String
    , error : Maybe String
    , onInput : String -> command
    }

{-| LabelModel

State for a labeled value

-}
type alias LabelModel =
    { key : String
    , label : String
    , value : String
    }

{-|
-}
styles : List Mixin -> Html.Attribute msg
styles =
    asPairs >> style
    
{-| flexColumn

Renders a div with flexbox enabled in column direction

-}
flexColumn : Int -> Html command -> Html command
flexColumn flexSize children =
    div
        [ styles
            [ flex (int flexSize)
            , displayFlex
            , flexDirection column
            ]
        ]
        [ children
        ]

{-|
-}
flexRow : Int -> Html command -> Html command
flexRow flexSize children =
    div
        [ styles
            [ flex (int flexSize)
            , displayFlex
            , flexDirection row
            ]
        ]
        [ children
        ]

{-|
-}
hiddenStyle : List Mixin
hiddenStyle =
    [ property "visibility" "hidden"
    , property "user-select" "none"
    ]

{-|
-}
errorLabel : ThemeCssClasses -> Maybe String -> Html command
errorLabel cssClass value =
    case value of
        Nothing ->
            div
                [ styles hiddenStyle
                ]
                [ Html.text ""
                ]
        Just error ->
            div
                [ theme.class
                    [ cssClass
                    ]
                ]
                [ Html.text error
                ]

inputType : InputTypes -> Attribute msg
inputType value =
    case value of

        TextField -> type_ "text"

        PasswordField -> type_ "password"

{-|
-}
inputField : InputModel command -> Html command
inputField model =
    label
        [ theme.class
            [ Theme_InputField
            ]
        , for <| model.key ++ "-field"
        ]
        [ span
            [ theme.class
                [ Theme_InputField_Label
                ]
            ]
            [ Html.text model.label
            ]
        , input
            [ id <| model.key ++ "-field"
            , theme.class <|
                case model.error of
                    Nothing ->
                        [ Theme_InputField_Input
                        ]
                    Just _ ->
                        [ Theme_InputField_Input
                        , Theme_InputField_InputError
                        ]
            , placeholder model.placeholder
            , inputType model.inputType
            , defaultValue model.value
            , value model.value
            , onInput model.onInput
            ]
            [
            ]
        , errorLabel Theme_InputField_Error model.error
        ]

{-|
-}
labelField : LabelModel -> Html command
labelField model =
    label
        [ theme.class
            [ Theme_LabelField
            ]
        , for <| model.key ++ "-field"
        ]
        [ span
            [ theme.class
                [ Theme_LabelField_Label
                ]
            ]
            [ Html.text model.label
            ]
        , span
            [ id <| model.key ++ "-field"
            , theme.class
                [ Theme_LabelField_Value
                ]
            , value model.value
            ]
            [ Html.text model.value
            ]
        ]
