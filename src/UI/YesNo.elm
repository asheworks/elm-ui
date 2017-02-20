module UI.YesNo exposing
  ( ThemeCssClasses(..)
  , theme
  , YesNoFieldModel
  , yesNoField
  )

import Html exposing (..)
import Html.Attributes as Attr
import Html.CssHelpers exposing (Namespace, withNamespace)
import Html.Events exposing (onClick)
import Css exposing (..)


{-|
-}
styles : List Mixin -> Html.Attribute msg
styles =
    asPairs >> Attr.style


{-| namespace

Isolates theme related styles from other css definitions

-}
theme : Namespace String a b c
theme =
    withNamespace "AsheWorks--Elm-UI--YesNo--"


{-| ThemeCssClasses

-}
type ThemeCssClasses
  = Theme_Wrapper
  | Theme_Button
  | Theme_Button_Selected
  | Theme_Button_UnSelected
  | Theme_YesButton
  | Theme_NoButton


{-| YesNoFieldModel

State for a yes no selection control

-}
type alias YesNoFieldModel command =
    { id : String
    , yesLabel : String
    , noLabel : String
    , value : Bool
    , onChange : String -> Bool -> command
    }


{-| selectedClass
-}
selectedClass : Bool -> List ThemeCssClasses
selectedClass value =
  if value then
    [ Theme_Button_Selected
    ]
  else
    [ Theme_Button_UnSelected
    ]


{-| buttonStyle
-}
buttonStyle : Bool -> List Mixin
buttonStyle selected =
  [ padding2 (px 10) (px 20)
  , height (px 35)
  , width (px 100)
  , margin (px 20)
  , displayFlex
  , alignItems center
  , property "justify-content" "center"
  , property "user-select" "none"
  ] ++
  if selected then
    [ backgroundColor (hex "#333")
    , outline3 (px 1) solid (hex "#ddd")
    , color (hex "#fff")
    , cursor default
    ]
  else
    [ backgroundColor (hex "#ddd")
    , outline3 (px 1) solid (hex "#555")
    , color (hex "#333")
    , cursor pointer
    ]

{-| yesNoField
-}
yesNoField : YesNoFieldModel command -> Html command
yesNoField model =
  div
    [ styles
        [ displayFlex
        , flex (int 1)
        , padding2 (px 10) (px 5)
        ]
    , theme.class
        [ Theme_Wrapper
        ]
    , Attr.id model.id
    ]
    [ div
        [ styles <|
            buttonStyle model.value
        , theme.class <|
            selectedClass model.value ++
            [ Theme_Button
            , Theme_YesButton
            ]
        , onClick <| model.onChange model.id True
        ]
        [ Html.text model.yesLabel
        ]
    , div
        [ styles <|
            buttonStyle (not model.value)
        , theme.class <|
            selectedClass (not model.value) ++
            [ Theme_Button
            , Theme_NoButton
            ]
        , onClick <| model.onChange model.id False
        ]
        [ Html.text model.noLabel
        ]
    ]
