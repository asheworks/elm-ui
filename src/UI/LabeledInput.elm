module UI.LabeledInput exposing
  ( ThemeCssClasses(..)
  , theme
  , InputTypes(..)
  , InputModel
  , inputType
  , labeledInput
  )


import Html exposing (..)
import Html.Attributes as Attr
import Html.CssHelpers exposing (Namespace, withNamespace)
import Html.Events exposing (onInput)
import Css exposing (..)


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
    withNamespace "AsheWorks--Elm-UI--LabeledInput--"


{-| ThemeCssClasses

-}
type ThemeCssClasses
  = Theme_Wrapper
  | Theme_Label
  | Theme_Input
  | Theme_Input_Error


{-| InputTypes
-}
type InputTypes
    = TextField
    | PasswordField


{-| InputModel

State for an input text box with placeholder and validation labels

-}
type alias InputModel command =
    { id : String
    , label : String
    , placeholder : String
    , inputType : InputTypes
    , value : String
    , error : Bool
    , onInput : String -> command
    }


{-| inputType
-}
inputType : InputTypes -> Attribute msg
inputType value =
    case value of

        TextField -> Attr.type_ "text"

        PasswordField -> Attr.type_ "password"


{-| inputField
-}
labeledInput : InputModel command -> Html command
labeledInput model =
  label
    [ theme.class
        [ Theme_Wrapper
        ]
    , Attr.for <| model.id ++ "-labeledInput"
    ]
    [ span
        [ theme.class
            [ Theme_Label
            ]
        ]
        [ Html.text model.label
        ]
    , input
        [ Attr.id <| model.id ++ "-labeledInput"
        , theme.class <|
            [ Theme_Input
            ] ++
            if model.error then
              [ Theme_Input_Error
              ]
            else
              [
              ]
        , Attr.placeholder model.placeholder
        , inputType model.inputType
        , Attr.defaultValue model.value
        , Attr.value model.value
        , onInput <| model.onInput
        ]
        [
        ]
    ]


-- {-| inputField
-- -}
-- inputField : InputModel command -> Html command
-- inputField model =
--     div
--         [ theme.class
--             [ Theme_InputField_Wrapper
--             ]
--         , Attr.id model.id
--         ]
--         [ label
--             [ theme.class
--                 [ Theme_InputField
--                 ]
--             , Attr.for <| model.id ++ "-inputField"
--             ]
--             [ span
--                 [ theme.class
--                     [ Theme_InputField_Label
--                     ]
--                 ]
--                 [ Html.text model.label
--                 ]
--             , input
--                 [ Attr.id <| model.id ++ "-inputField"
--                 , theme.class <|
--                     case model.error of
--                         Nothing ->
--                             [ Theme_InputField_Input
--                             ]
--                         Just _ ->
--                             [ Theme_InputField_Input
--                             , Theme_InputField_Input_Error
--                             ]
--                 , Attr.placeholder model.placeholder
--                 , inputType model.inputType
--                 , Attr.defaultValue model.value
--                 , Attr.value model.value
--                 , onInput model.onInput
--                 ]
--                 [
--                 ]
--             , errorLabel Theme_InputField_Error model.error
--             ]
--         ]