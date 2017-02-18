module Example.View exposing (..)

import Html exposing (..)
import Set exposing (..)

--

import Example.FormBuilder as FormBuilder

--
import Example.Style exposing (..)
import Example.Model exposing (Command(..), Model)
import Example.Questionnaire exposing (..)
--

import UI as UI
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

-- , Html.map FormBuilder_Command <| FormBuilder.buildForm questionnaire sampleData

view : Model -> Html Command
view model =
    List.map wrapper
        [ ( "Form Builder"
          , Html.map FormBuilder_Command <| FormBuilder.buildForm questionnaire model.questionnaire.state
          )
        -- , ( "Simple Input Form", simpleInputForm )
        -- , ( "Simple Input Form with Error", simpleInputFormWithError )
        -- , ( "Simple Text Area Form", simpleTextAreaForm )
        -- , ( "Simple Checkbox Form", simpleCheckboxForm )
        , ( "Complex Form", complexForm )        
        ]
        |> div [ class [ Component ] ]

simpleInputForm : Html Command
simpleInputForm =
    UI.formControl
        { id = "simple-input-form"
        , header = Nothing
        , section = Just
            [ UI.inputField
                { id = "property"
                , label = "Property: "
                , placeholder = "e.g. placeholder"
                , inputType = UI.TextField
                , value = "Property"
                , error = Nothing
                , onInput = UpdateProperty
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
            [ UI.inputField
                { id = "property"
                , label = "Property: "
                , placeholder = "e.g. placeholder"
                , inputType = UI.TextField
                , value = "Property"
                , error = Nothing
                , onInput = UpdateProperty
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
                , onInput = UpdateProperty
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
            [ UI.inputField
                { id = "property-1"
                , label = "Property 1: "
                , placeholder = "e.g. placeholder 1"
                , inputType = UI.TextField
                , value = "Property 1"
                , error = Nothing
                , onInput = UpdateProperty
                }
            , UI.inputField
                { id = "property-2"
                , label = "Property 2: "
                , placeholder = "e.g. placeholder 2"
                , inputType = UI.TextField
                , value = "Property 2"
                , error = Nothing
                , onInput = UpdateProperty
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