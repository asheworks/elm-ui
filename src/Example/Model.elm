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
import Example.Questionnaire as Questionnaire
--

type alias ContextValues =
    {}


type alias Context =
    Maybe ContextValues


type alias Model =
    { questionnaire : State Questionnaire.SampleData
    }


type Command
    = Submit
    | ToggleEntry String
    | UpdateProperty String
    | FormBuilder_Command FormBuilder.Command

type Event
    = Submitted
    | ToggledEntry String
    | UpdatedProperty String
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
    { questionnaire = State Questionnaire.sampleData
    }
