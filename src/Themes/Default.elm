module Themes.Default exposing
  ( css
  )

{-| This is the default theme for the Elm-UI library

@docs css

-}

import Css exposing (..)
import Css.Namespace exposing (namespace)
-- import Html.CssHelpers exposing (Namespace)
import UI exposing (..)

--, border3 (px 1) solid (hex "#f00")

{-| css

-}
css : UI.Theme b command -> Stylesheet
css themeNamespace =
    (stylesheet << namespace themeNamespace.name)
        [ (.) Theme_Error
            [
            ]
        
        , (.) Theme_FormWrapper
            [ border3 (px 1) dashed (rgba 255 128 128 0.5)
            , padding (px 15)
            ]
        , (.) Theme_FormHeader
            [
            ]
        , (.) Theme_FormSection
            [
            ]
        , (.) Theme_FormAside
            [
            ]
        , (.) Theme_FormFooter
            [
            ]

        , (.) Theme_FormTitle
            [ fontSize (px 30)
            , color (hex "#555")
            ]
        , (.) Theme_FormError
            [ flex (int 1)
            , color (hex "#900")
            ]

        , (.) Theme_Section_Wrapper
            [
            ]
        , (.) Theme_Section_Header
            [
            ]

        , (.) Theme_FieldSet_Wrapper
            [
            ]

        , (.) Theme_CheckboxField_Wrapper
            [
            ]
        , (.) Theme_CheckboxField_UnorderedList
            [
            ]
        , (.) Theme_CheckboxField_ListItem
            [
            ]
        , (.) Theme_CheckboxField
            [
            ]
        , (.) Theme_CheckboxField_Label
            [
            ]
        , (.) Theme_CheckboxField_Input
            [
            ]
        , (.) Theme_CheckboxField_Input_Error
            [
            ]
        , (.) Theme_CheckboxField_Error
            [
            ]

        , (.) Theme_InputField_Wrapper
            [ flex (int 1)
            ]
        , (.) Theme_InputField
            [
            ]
        , (.) Theme_InputField_Label
            [ fontSize (Css.em 1)
            , property "user-select" "none"
            ]
        , (.) Theme_InputField_Input
            [ flex (int 1)
            , padding2 (px 5) (px 10)
            , fontSize (Css.em 1.1)
            , borderRadius (px 4)
            , border3 (px 1) solid (hex "#BBB")
            -- , marginBottom (px 20)
            ]
        , (.) Theme_InputField_Input_Error
            [ outline3 (px 1) solid (hex "#f00")
            ]
        , (.) Theme_InputField_Error
            [
            ]

        , (.) Theme_LabelField_Wrapper
            [ flex (int 1)
            , padding2 (px 5) (px 5)
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

        , (.) Theme_SubmitButton_Wrapper
            [ flex (int 1)
            ]
        , (.) Theme_SubmitButton
            [ displayFlex
            , width (px 200)
            , height (px 55)
            , backgroundColor (hex "#000")
            ]
        , (.) Theme_SubmitButton_Label
            [ color (hex "#fff")
            , property "justify-content" "center"
            , flexDirection column
            , displayFlex
            , textAlign center
            , flex (int 1)
            ]

        , (.) Theme_TextAreaField_Wrapper
            [
            ]
        , (.) Theme_TextAreaField
            [
            ]
        , (.) Theme_TextAreaField_Label
            [
            ]
        , (.) Theme_TextAreaField_Input
            [
            ]
        , (.) Theme_TextAreaField_Input_Error
            [
            ]
        , (.) Theme_TextAreaField_Error
            [
            ]

        , (.) Theme_YesNoField_Wrapper
            [ displayFlex
            , flexDirection row
            ]
        , (.) Theme_YesNoField
            [ displayFlex
            , flexDirection row
            ]
        , (.) Theme_YesNoField_Button
            [ width (px 50)
            , height (px 25)
            , padding2 (px 5) (px 10)
            , border3 (px 1) solid (hex "#000")
            , margin2 (px 5) (px 10)
            , cursor pointer
            , alignItems center
            , textAlign center
            ]
        , (.) Theme_YesNoField_Button_Selected
            [ border3 (px 3) solid (hex "#000")
            ]
        , (.) Theme_YesNoField_YesButton
            [ backgroundColor (hex "#0f0")
            ]
        , (.) Theme_YesNoField_YesButton_Selected
            [
            ]
        , (.) Theme_YesNoField_NoButton
            [ backgroundColor (hex "#f00")
            ]
        , (.) Theme_YesNoField_NoButton_Selected
            [
            ]
        , (.) Theme_YesNoField_Error
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