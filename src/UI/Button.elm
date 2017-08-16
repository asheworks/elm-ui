module UI.Button
    exposing
        ( theme
        , ThemeCssClasses(..)
        , Model
        , view
        )

import Html exposing (..)
import Html.Attributes as Attr
import Html.CssHelpers exposing (Namespace, withNamespace)
import Html.Events exposing (onClick, on, keyCode)
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
    withNamespace "AsheWorks--Elm-UI--Button--"


{-| ThemeCssClasses

-}
type ThemeCssClasses
    = Theme_Button_Wrapper
    | Theme_Button
    | Theme_Button_Error


{-| ButtonModel

State for a button with validation highlighting

-}
type alias Model command =
    { id : String
    , label : String
    , error : Bool
    , onClick : command
    , onKeyDown : Int -> command
    }


{-| view

-}
view : Model command -> Html command
view model =
    div
        [ theme.class
            [ Theme_Button_Wrapper
            ]
        , styles
            [ flex (int 1)
            , paddingLeft (px 100)
            , paddingRight (px 100)
            , paddingTop (px 20)
            , paddingBottom (px 20)
            ]
        , Attr.id model.id
        , on "keyDown" <| (Json.map model.onKeyDown keyCode)
        ]
        [ div
            [ theme.class
                [ Theme_Button
                ]
            , styles
                [ displayFlex
                , flex (int 1)
                  -- , width (px 200)
                , height (px 55)
                  -- , backgroundColor (hex "#000")
                ]
            , onClick <| model.onClick
            ]
            [ span
                [ theme.class
                    [--Theme_Button_Error
                    ]
                , styles
                    [ property "justify-content" "center"
                    , flexDirection column
                    , displayFlex
                    , textAlign center
                    , flex (int 1)
                    ]
                ]
                [ Html.text model.label
                ]
            ]
        ]



--  , (.) Theme_SubmitButton_Wrapper
--           [ flex (int 1)
--           ]
--       , (.) Theme_SubmitButton
--           [ displayFlex
--           , width (px 200)
--           , height (px 55)
--           , backgroundColor (hex "#000")
--           ]
--       , (.) Theme_SubmitButton_Label
--           [ color (hex "#fff")
--           , property "justify-content" "center"
--           , flexDirection column
--           , displayFlex
--           , textAlign center
--           , flex (int 1)
--           ]
