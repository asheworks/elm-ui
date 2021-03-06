module Example.View exposing (..)

import Html exposing (..)
import Set exposing (..)

--

-- import Example.FormBuilder2 as FB2
import Example.FormBuilder as FB3
import Example.InfoSec as FB3
-- import Example.FormBuilder as FormBuilder

--
import Example.Style exposing (..)
import Example.Model exposing (Command(..), Model)
-- import Example.Questionnaire exposing (..)
--

import UI as UI
import UI.Input
import UI.FieldLabel
-- import UI.LabeledInput as UI

--

{ id, class, classList } =
    cssNamespace

--

wrapper : ( String, Html Command ) -> Html Command
wrapper ( label, child ) =
    [ span
        [ class
            [ Label
            ]
        ]
        [ text label
        ]
    , child
    ]
        |> div [ class [ Container ] ]

-- view : Model -> Html Command
-- view model =
--     Html.map FormBuilder_Command <| FormBuilder.buildForm questionnaire sampleData

view : Model -> Html Command
view model =
  let
    form =
      FB3.toForm
      FB3.toDataType
      FB3.infosec
      { visible = False
      }
  in
    Html.map FormBuilder_Command form.view


-- view : Model -> Html Command
-- view model =
    -- List.map wrapper
    --     [ ( "Form Builder"
    --       , Html.map FormBuilder_Command <| FormBuilder.buildForm questionnaire model.questionnaire.state
    --       )
    --     -- , ( "Simple Input Form", simpleInputForm )
    --     -- , ( "Simple Input Form with Error", simpleInputFormWithError )
    --     -- , ( "Simple Text Area Form", simpleTextAreaForm )
    --     -- , ( "Simple Checkbox Form", simpleCheckboxForm )
    --     -- , ( "Complex Form", complexForm )        
    --     ]
    --     |> div [ class [ Component ] ]

-- formBuilder : Model -> Html Command
-- formBuilder model =
--     Html.map FormBuilder_Command
--         <| FormBuilder.buildForm
--             questionnaire
--             model.questionnaire.state

-- formBuilder2 : Model -> Html Command
-- formBuilder2 model =
--     Html.map 

simpleInputForm : Html Command
simpleInputForm =
    UI.formControl
        { id = "simple-input-form"
        , header = Nothing
        , section = Just
            -- [ UI.labeledInput
            [ UI.Input.view
                { id = "property"
                -- , label = "Property: "
                , placeholder = "e.g. placeholder"
                , inputType = UI.Input.TextField
                , value = "Property"
                , error = False
                , onInput = InputUpdate
                }
            , UI.submitButton
                { id = "submit"
                , label = "SUBMIT"
                , onClick = Submit
                }
            ]
        , aside = Nothing
        , footer = Nothing
        }


simpleInputFormWithError : Html Command
simpleInputFormWithError =
    UI.formControl
        { id = "simple-input-form-with-error"
        , header = Just
            [ UI.formTitle "Simple Input Form With Error"
            ]
        , section = Just
            -- [ UI.labeledInput
            [ UI.Input.view
                { id = "property"
                -- , label = "Property: "
                , placeholder = "e.g. placeholder"
                , inputType = UI.Input.TextField
                , value = "Property"
                , error = False
                , onInput = InputUpdate
                }
            , UI.submitButton
                { id = "submit"
                , label = "SUBMIT"
                , onClick = Submit
                }
            ]
        , aside = Nothing
        , footer = Just
            [ UI.formError <| Just "Error has occurred"
            ]
        }

simpleTextAreaForm : Html Command
simpleTextAreaForm =
    UI.formControl
        { id = "simple-textarea-form"
        , header = Nothing
        , section = Just
            [ UI.textAreaField
                { id = "property"
                , label = "Property: "
                , placeholder = "e.g. placeholder"
                , rows = 2
                , cols = 40
                , value = "Property"
                , error = Nothing
                , onInput = InputUpdate
                }
            , UI.submitButton
                { id = "submit"
                , label = "SUBMIT"
                , onClick = Submit
                }
            ]
        , aside = Nothing
        , footer = Nothing
        }

simpleCheckboxForm : Html Command
simpleCheckboxForm =
    UI.checkboxControl
        { id = "simple-checkbox-form"
        , values =
            [   { key = "one"
                , value = "1 - One"
                , checked = False
                , error = Nothing
                }
            ,   { key = "two"
                , value = "2 - Two"
                , checked = True
                , error = Nothing
                }
            ]
        , error = Nothing
        , onSelect = ToggleEntry
        }

complexForm : Html Command
complexForm =
    UI.formControl
        { id = "simple-form"
        , header = Just
            [ UI.formTitle "Complex Form"
            ]
        , section = Just
            -- [ UI.labeledInput
            [ UI.FieldLabel.view
                { id = "property-1"
                , label = "Property 1: "
                , error = False
                }
                [ UI.Input.view
                    { id = "property-1"
                    -- , label = "Property 1: "
                    , placeholder = "e.g. placeholder 1"
                    , inputType = UI.Input.TextField
                    , value = "Property 1"
                    , error = False
                    , onInput = InputUpdate
                    }
                ]
            -- , UI.labeledInput
            , UI.FieldLabel.view
                { id = "property-2"
                , label = "Property 2: "
                , error = False
                }
                [ UI.Input.view
                    { id = "property-2"
                    -- , label = "Property 2: "
                    , placeholder = "e.g. placeholder 2"
                    , inputType = UI.Input.TextField
                    , value = "Property 2"
                    , error = False
                    , onInput = InputUpdate
                    }
                ]
            , UI.submitButton
                { id = "submit"
                , label = "SUBMIT"
                , onClick = Submit
                }
            ]
        , aside = Nothing
        , footer = Nothing
        }