module UI.Input exposing
  ( theme
  , ThemeCssClasses(..)
  , InputTypes(..)
  , InputModel
  , view
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
    withNamespace "AsheWorks--Elm-UI--Checkbox--"


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
type alias CheckboxModel command =
    { id : String
    , key : String
    , value : String
    , checked : Bool
    , onClick : String -> String -> command
    }


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
      ] ++
      if model.error then
        [ outline3 (px 1) solid (hex "#f00")
        ]
      else
        [
        ]
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
    , Attr.type_ "checkbox"
    , Attr.defaultValue model.value
    , Attr.value model.value
    , onInput <| model.onInput model.id
    ]
    [
    ]