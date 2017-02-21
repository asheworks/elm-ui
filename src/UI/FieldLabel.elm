module UI.FieldLabel exposing
  ( theme
  , ThemeCssClasses(..)
  , view
  )

import Html exposing (..)
import Html.Attributes as Attr
import Html.CssHelpers exposing (Namespace, withNamespace)
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
    withNamespace "AsheWorks--Elm-UI--FieldLabel--"


{-| ThemeCssClasses

-}
type ThemeCssClasses
  = Theme_Wrapper
  | Theme_Wrapper_Error
  | Theme_Label
  | Theme_Label_Error


{-| FieldLabelModel
-}
type alias FieldLabelModel =
  { id : String
  , label : String
  , error : Bool
  }


{-| view

-}
view : FieldLabelModel -> List (Html command) -> Html command
view model children =
  label
    [ styles
      [ flex (int 1)
      , displayFlex
      , flexDirection column
      , paddingTop (px 10)
      , width (pct 100)
      ]
    , theme.class <|
      [ Theme_Wrapper
      ] ++
      if model.error then
        [ Theme_Wrapper_Error
        ]
      else
        []
    , Attr.for <| model.id
    ] <|
    [ span
      [ styles <|
        [ property "user-select" "none"
        , textAlign center
        , fontSize (Css.em 1.3)
        , textDecoration underline
        , displayFlex
        , property "align-content" "flex-start"
        , padding2 (px 10) (px 0)
        ] ++
        if model.error then
          [ color (hex "#f00")
          ]
        else
          []

      , theme.class <|
          [ Theme_Label
          ] ++
          if model.error then
            [ Theme_Label_Error
            ]
          else
            []
      ]
      [ Html.text model.label
      ]
    ] ++
    children