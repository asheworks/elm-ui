module Themes.Default exposing
  ( css
  )

import Css exposing (..)
import Css.Namespace exposing (namespace)
-- import Html.CssHelpers exposing (Namespace)
import Forms exposing (..)

css : Forms.Theme b command -> Stylesheet
css themeNamespace =
    (stylesheet << namespace themeNamespace.name)
        [ (.) Theme_InputField
            [
            ]
        , (.) Theme_InputField_Label
            [ 
            ]
        , (.) Theme_InputField_Input
            [ flex (int 1)
            , padding2 (px 15) (px 20)
            , fontSize (Css.em 1.3)
            , borderRadius (px 4)
            , border3 (px 1) solid (hex "#BBB")
            , marginBottom (px 20)
            ]
        , (.) Theme_InputField_InputError
            [ outline3 (px 1) solid (hex "#f00")
            ]
        , (.) Theme_InputField_Error
            [
            ]
        , (.) Theme_LabelField
            [
            ]
        , (.) Theme_LabelField_Label
            [ flex (int 1)
            , color (rgb 64 64 64)
            , paddingTop (px 10)
            , fontSize (Css.em 1.2)
            , property "user-select" "none"
            , textAlign center
            ]
        , (.) Theme_LabelField_Value
            [
            ]
        , (.) Theme_FormError
            [
            ]
        ]


-- {-|
-- -}
-- labelStyleDefault : List Mixin
-- labelStyleDefault =
--     [ flex (int 1)
--     , color (rgb 64 64 64)
--     , paddingTop (px 10)
--     , fontSize (Css.em 1.1)
--     , property "user-select" "none"
--     , textAlign center
--     ]

-- {-|
-- -}
-- labelErrorStyleDefault : List Mixin
-- labelErrorStyleDefault =
--     [ flex (int 1)
--     , color (rgb 255 0 0)
--     , paddingTop (px 10)
--     , fontSize (Css.em 1.1)
--     , property "user-select" "none"
--     , textAlign center
--     ]