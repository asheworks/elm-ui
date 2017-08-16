module Example.Model
    exposing
        ( Command(..)
        , Event(..)
        , Effect(..)
        , Context
        , ContextValues
        , Model
        , mapContext
        , mapValues
        , defaultModel
        )

--

import CQRS exposing (State)

--

import Example.FormBuilder as FormBuilder
-- import Example.Questionnaire as Questionnaire
--

type alias ContextValues =
    {}


type alias Context =
    Maybe ContextValues


type alias Model =
    { --questionnaire : State Questionnaire.SampleData
    }


type Command
    = Submit
    | ToggleEntry (Int, String)
    | InputUpdate String String
    | FormBuilder_Command FormBuilder.Command

type Event
    = Submitted
    | ToggledEntry (Int, String)
    | InputUpdated String String
    | FormBuilder_Event FormBuilder.Event


type Effect
    = FormBuilder_Effect FormBuilder.Effect
    

mapContext : Context -> Model
mapContext context =
    Maybe.withDefault
        {}
        context
        |> mapValues


mapValues : ContextValues -> Model
mapValues values =
    defaultModel


defaultModel : Model
defaultModel =
    { --questionnaire = State Questionnaire.sampleData
    }
