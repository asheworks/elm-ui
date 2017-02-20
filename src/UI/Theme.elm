module UI.Theme exposing
  ( ThemeCssClasses(..)
  , Theme
  , theme
  , themes
  , styles
  )

{-| Theme provides base compositional and descriptive aids for declaring and implemnting UI themes

## Style Definitions
@docs theme, themes, ThemeCssClasses, Theme
@docs styles

-}

import Css exposing (..)
import Html exposing (..)
import Html.Attributes as Attr
import Html.CssHelpers exposing (Namespace, withNamespace)

--

import UI.YesNo as YesNo

--

{-| namespace

Isolates theme related styles from other css definitions

-}
theme : Namespace String a b c
theme =
    withNamespace "AsheWorks--Elm-UI--Theme--"

{-| themes
-}

themes : List (Namespace String a b c)
themes =
  [ theme
  , YesNo.theme
  ]

{-| Theme

-}
type alias Theme b command = Namespace String ThemeCssClasses b command

{-|
-}
styles : List Mixin -> Html.Attribute msg
styles =
    asPairs >> Attr.style


{-| ThemeCssClasses
-}
type ThemeCssClasses
    = Theme_Error

    | Theme_FormWrapper
    | Theme_FormHeader
    | Theme_FormSection
    | Theme_FormAside
    | Theme_FormFooter

    | Theme_FormTitle
    | Theme_FormError

    | Theme_Section_Wrapper
    | Theme_Section_Header

    | Theme_FieldSet_Wrapper

    | Theme_CheckboxField_Wrapper
    | Theme_CheckboxField_UnorderedList
    | Theme_CheckboxField_ListItem
    | Theme_CheckboxField
    | Theme_CheckboxField_Label
    | Theme_CheckboxField_Input
    | Theme_CheckboxField_Input_Error
    | Theme_CheckboxField_Error

    | Theme_InputField_Wrapper
    | Theme_InputField
    | Theme_InputField_Label
    | Theme_InputField_Input
    | Theme_InputField_Input_Error
    | Theme_InputField_Error

    | Theme_LabelField_Wrapper
    | Theme_LabelField
    | Theme_LabelField_Label
    | Theme_LabelField_Value

    | Theme_SubmitButton_Wrapper
    | Theme_SubmitButton
    | Theme_SubmitButton_Label

    | Theme_TextAreaField_Wrapper
    | Theme_TextAreaField
    | Theme_TextAreaField_Label
    | Theme_TextAreaField_Input
    | Theme_TextAreaField_Input_Error
    | Theme_TextAreaField_Error

    | YesNo YesNo.ThemeCssClasses

    -- | Theme_YesNoField_Wrapper
    -- | Theme_YesNoField
    -- | Theme_YesNoField_Button
    -- | Theme_YesNoField_Button_Selected
    -- | Theme_YesNoField_YesButton
    -- | Theme_YesNoField_YesButton_Selected
    -- | Theme_YesNoField_NoButton
    -- | Theme_YesNoField_NoButton_Selected
    -- | Theme_YesNoField_Error