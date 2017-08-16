module UI exposing
  ( errorLabel
  , hiddenStyle
  , h1Label
  , h2Label
  , h3Label
  , icon
  

  , FormModel
  , formTitle
  , formError
  , formControl

  , CheckboxModel
  , checkboxEntry
  , checkboxControl

--   , InputTypes(..)
--   , InputModel
--   , inputType
--   , inputField

  , LabelModel
  , labelField
  
  , SubmitButtonModel
  , submitButton

  , TextAreaModel
  , textAreaField

--   , YesNoFieldModel
--   , yesNoField

  )

{-| This library contains common UI control definitions

## Form Element Types

## General

@docs hiddenStyle, icon, titleLabel, errorLabel

## Form

@docs FormModel, formTitle, formError, formControl

## Checkbox

@docs CheckboxModel, checkboxEntry, checkboxControl

## Inputs

@docs InputTypes, InputModel, inputField

## Labels

@docs LabelModel, labelField

## Submit

@docs SubmitButtonModel, submitButton

## TextArea

@docs TextAreaModel, textAreaField

-- ## YesNo

-- @docs YesNoModel, yesNoField


-}



--
-- Semantic Forms:
-- https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Forms/How_to_structure_an_HTML_form
--

import Html exposing (..)
-- import Html.Attributes exposing (alt, defaultValue, for, id, placeholder, required, src, style, type_, value)
import Html.Attributes as Attr
import Html.CssHelpers exposing (Namespace, withNamespace)
import Html.Events exposing (onInput, onClick)
import Css exposing (..)

-- import Array exposing (..)
--

import UI.Theme exposing (..)

{-|
-}
hiddenStyle : List Mixin
hiddenStyle =
    [ property "visibility" "hidden"
    , property "user-select" "none"
    ]

{-|
-}
icon : ThemeCssClasses -> Html command
icon cssClass =
    Html.img
        [ theme.class
            [ cssClass
            ]
        , Attr.src "url"
        , Attr.alt "alt text"
        ]
        [
        ]

{-|
-}
h1Label : ThemeCssClasses -> String -> Html command
h1Label cssClass value =
    Html.h1
        [ theme.class
            [ cssClass
            ]
        ]
        [ Html.text value
        ]

{-|
-}
h2Label : ThemeCssClasses -> String -> Html command
h2Label cssClass value =
    Html.h2
        [ theme.class
            [ cssClass
            ]
        ]
        [ Html.text value
        ]

{-|
-}
h3Label : ThemeCssClasses -> String -> Html command
h3Label cssClass value =
    Html.h3
        [ theme.class
            [ cssClass
            ]
        ]
        [ Html.text value
        ]

{-|
-}
errorLabel : ThemeCssClasses -> Maybe String -> Html command
errorLabel cssClass value =
    case value of
        Nothing ->
            span
                [ styles hiddenStyle
                ]
                [ Html.text ""
                ]
        Just error ->
            span
                [ theme.class
                    [ Theme_Error
                    , cssClass
                    ]
                ]
                [ Html.text error
                ]

{-| FormModel
-}
type alias FormModel command =
    { id : String
    , header : Maybe (List (Html command))
    , section : Maybe (List (Html command))
    , aside : Maybe (List (Html command))
    , footer : Maybe (List (Html command))
    }

{-|
-}
formTitle : String -> Html command
formTitle value =
    h1Label Theme_FormTitle value

{-|
-}
formError : Maybe String -> Html command
formError value =
    errorLabel Theme_FormError value

{-| formControl
-}
formControl : FormModel command -> Html command
formControl model =
    form
        [ theme.class
            [ Theme_FormWrapper
            ]
        , Attr.id model.id
        ]
        [ header
            [ styles
                [ --fontSize (Css.em 2)
                -- , textAlign center
                -- , backgroundColor (hex "#555")
                -- , color (hex "#DDD")
                -- , padding (px 30)
                ]
            , theme.class
                [ Theme_FormHeader
                ]
            ]
            <| Maybe.withDefault [] model.header
        , section
            [ styles
                [ --paddingTop (px 20)
                ]
            , theme.class
                [ Theme_FormSection
                ]
            ]
            <| Maybe.withDefault [] model.section
        , aside
            [ theme.class
                [ Theme_FormAside
                ]
            ]
            <| Maybe.withDefault [] model.aside
        , footer
            [ theme.class
                [ Theme_FormFooter
                ]
            ]
            <| Maybe.withDefault [] model.footer
        ]


{-| KeyValue
-}
type alias KeyValueError =
    { key : String
    , value : String
    , checked : Bool
    , error : Maybe String
    }

{-| CheckboxModel
-}
type alias CheckboxModel command =
    { id : String
    , values : List KeyValueError
    , error : Maybe String
    , onSelect : String -> command
    -- , onSelect : String -> String -> command
    -- , onSelect : (Int, String) -> command
    }

checkboxEntry : CheckboxModel command -> Int -> KeyValueError -> Html command
checkboxEntry parentModel index model =
    label
        [ styles
            [ displayFlex
            , flexDirection rowReverse
            -- , width (px 300)
            ]
        , theme.class
            [ Theme_CheckboxField
            ]
        ]
        [ span
            [ styles
                [ property "user-select" "none"
                , flex (int 1)
                , displayFlex
                , flexDirection column
                , property "justify-content" "center"
                , fontSize (Css.em 1.3)
                ]
            , theme.class
                [ Theme_CheckboxField_Label
                ]
            ]
            [ Html.text model.value
            ]
        , div
            [ styles
                [ padding2 (px 10) (px 20) --flex (int 1)
                ]
            ]
            [ div
                [ styles
                    [ width (px 30)
                    , height (px 30)
                    , property "background" "#ddd"
                    , displayFlex
                    , flexDirection row
                    -- , margin2 (px 20) (px 90)
                    -- , borderRadius (pct 100)
                    , position relative
                    , boxShadow4 (px 0) (px 1) (px 2) (rgba 0 0 0 0.5)
                    ]
                , onClick ( parentModel.onSelect model.key )
                -- , onClick (parentModel.onSelect (index, model.key))
                ]
                [ input
                    [ Attr.id <| parentModel.id ++ toString index ++ "-checkboxField"
                    , theme.class <|
                        case model.error of
                            Nothing ->
                                [ Theme_CheckboxField_Input
                                ]
                            Just _ ->
                                [ Theme_CheckboxField_Input
                                , Theme_CheckboxField_Input_Error
                                ]
                    , Attr.value model.key
                    , Attr.type_ "checkbox"
                    , Attr.checked model.checked
                    , styles
                        [ display none
                        ]
                    ]
                    [
                    ]
                , label
                    [ styles <|
                        [ display block
                        , width (px 24)
                        , height (px 24)
                        -- , borderRadius (px 100)

                        -- , property "transition" "all .2s ease"
                        , cursor pointer
                        , position absolute
                        , top (px 3)
                        , left (px 3)
                        , property "z-index" "1"
                        , property "box-shadow" "inset 0px 1px 2px rgba(0,0,0,0.5)"
                        ] ++
                        if model.checked then
                            [ property "background" "#333"
                            ]
                        else
                            [ property "background" "#ddd"
                            ]
                    ]
                    [
                    ]
                ]
            ]
        ]


checkboxListItem : Html command -> Html command
checkboxListItem child =
    li
        [ theme.class
            [ Theme_CheckboxField_ListItem
            ]
        ]
        [ child
        ]


checkboxControl : CheckboxModel command -> Html command
checkboxControl model =
    let
        entries =
            List.indexedMap (checkboxEntry model) model.values

        wrappedEntries =
            List.map checkboxListItem entries
    in
    div
        [ theme.class
            [ Theme_CheckboxField_Wrapper
            ]
        , Attr.id model.id
        ]
        [ ul
            [ theme.class
                [ Theme_CheckboxField_UnorderedList
                ]
            ]
            wrappedEntries
        , errorLabel Theme_CheckboxField_Error model.error
        ]


-- {-| InputTypes
-- -}
-- type InputTypes
--     = TextField
--     | PasswordField

-- {-| InputModel

-- State for an input text box with placeholder and validation labels

-- -}
-- type alias InputModel command =
--     { id : String
--     , label : String
--     , placeholder : String
--     , inputType : InputTypes
--     , value : String
--     , error : Maybe String
--     , onInput : String -> command
--     }

-- {-| inputType
-- -}
-- inputType : InputTypes -> Attribute msg
-- inputType value =
--     case value of

--         TextField -> Attr.type_ "text"

--         PasswordField -> Attr.type_ "password"

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

{-| LabelModel

State for a labeled value

-}
type alias LabelModel =
    { id : String
    , label : String
    , value : String
    }

{-|
-}
labelField : LabelModel -> Html command
labelField model =
    div
        [ theme.class
            [ Theme_LabelField_Wrapper
            ]
        , Attr.id model.id
        ]
        [ label
            [ theme.class
                [ Theme_LabelField
                ]
            , Attr.for <| model.id ++ "-field"
            ]
            [ Html.section
                [ theme.class
                    [ Theme_LabelField_Label
                    ]
                ]
                [ Html.text model.label
                ]
            , Html.aside
                [ Attr.id <| model.id ++ "-field"
                , theme.class
                    [ Theme_LabelField_Value
                    ]
                , Attr.value model.value
                ]
                [ Html.text model.value
                ]
            ]
        ]

{-| SubmitButtonModel

State for a submit button control

-}
type alias SubmitButtonModel command =
    { id : String
    , label : String
    -- , error : Maybe String
    , onClick : command
    }

{-| submitButton
-}
submitButton : SubmitButtonModel command -> Html command
submitButton model =
    div
        [ theme.class
            [ Theme_SubmitButton_Wrapper
            ]
        , Attr.id model.id
        ]
        [ div
            [ theme.class
                [ Theme_SubmitButton
                ]
            , onClick model.onClick
            ]
            [ span
                [ theme.class
                    [ Theme_SubmitButton_Label
                    ]
                ]
                [ Html.text model.label
                ]
            ]
        ]

{-| TextAreaModel

State for an input text area box with placeholder and validation labels

-}
type alias TextAreaModel command =
    { id : String
    , label : String
    , placeholder : String
    , rows : Int
    , cols : Int
    , value : String
    , error : Maybe String
    , onInput : String -> String -> command
    }

{-| textAreaField
-}
textAreaField : TextAreaModel command -> Html command
textAreaField model =
    div
        [ theme.class
            [ Theme_TextAreaField_Wrapper
            ]
        , Attr.id model.id
        ]
        [ label
            [ theme.class
                [ Theme_TextAreaField
                ]
            , Attr.for <| model.id ++ "-textAreaField"
            ]
            [ span
                [ theme.class
                    [ Theme_TextAreaField_Label
                    ]
                ]
                [ Html.text model.label
                ]
            , textarea
                [ Attr.id <| model.id ++ "-textAreaField"
                , theme.class <|
                    case model.error of
                        Nothing ->
                            [ Theme_TextAreaField_Input
                            ]
                        Just _ ->
                            [ Theme_TextAreaField_Input
                            , Theme_TextAreaField_Input_Error
                            ]
                , Attr.placeholder model.placeholder
                , Attr.rows model.rows
                , Attr.cols model.cols
                , Attr.defaultValue model.value
                , Attr.value model.value
                , onInput <| model.onInput model.id
                ]
                [
                ]
            , errorLabel Theme_TextAreaField_Error model.error
            ]
        ]


-- {-| YesNoFieldModel

-- State for a yes no selection control

-- -}
-- type alias YesNoFieldModel command =
--     { id : String
--     , yesLabel : String
--     , noLabel : String
--     , value : Bool
--     , error : Maybe String
--     , onChange : Bool -> command
--     }

-- {-| yesNoField
-- -}
-- yesNoField : YesNoFieldModel command -> Html command
-- yesNoField model =
--     div
--         [ theme.class
--             [ Theme_YesNoField_Wrapper
--             ]
--         , Attr.id model.id
--         ]
--         [ label
--             [ theme.class
--                 [ Theme_YesNoField
--                 ]
--             ]
--             [ div
--                 [ theme.class
--                   <| List.append
--                     [ Theme_YesNoField_Button
--                     , Theme_YesNoField_YesButton
--                     ]
--                     <| if model.value then
--                       [ Theme_YesNoField_Button_Selected
--                       , Theme_YesNoField_YesButton_Selected
--                       ]
--                     else
--                       []
--                 , onClick <| model.onChange True
--                 ]
--                 [ Html.text model.yesLabel
--                 ]
--             , div
--                 [ theme.class
--                   <| List.append
--                     [ Theme_YesNoField_Button
--                     , Theme_YesNoField_NoButton
--                     ]
--                     <| if not model.value then
--                       [ Theme_YesNoField_Button_Selected
--                       , Theme_YesNoField_NoButton_Selected
--                       ]
--                     else
--                       []
--                 , onClick <| model.onChange False
--                 ]
--                 [ Html.text model.noLabel
--                 ]
--             ]
--         , errorLabel Theme_YesNoField_Error model.error
--         ]