module Example.FormBuilder exposing
  ( Command(..)
  , Event(..)
  , Effect(..)
  , BulletTypes(..)
  , SectionKinds(..)
  , SectionModel
  , FieldTypes(..)
  , InputFieldModel
  , LabeledTextFieldModel
  , RadioFieldModel
  , BoolFieldModel
  , commandMap
  , eventMap
  , buildForm
  , leafToForm
  , branchToForm
  , formZipper
  )

import Set exposing (..)
-- import Date exposing (..)
import Html exposing (..)

--

import UI as UI
import Example.MetaTree exposing (..)

--

-- import Example.Model exposing (Command(..), Model)

--

type Command
  = InputField_Update String String

type Event
  = InputField_Updated String String

type Effect
  = None

commandMap : MetaTree (FieldTypes model) SectionModel -> model -> Command -> Event
commandMap tree model command =
  case Debug.log "FormBuilder - CommandMap" command of
    
    InputField_Update id value ->
      InputField_Updated id value

eventMap : MetaTree (FieldTypes model) SectionModel -> model -> Event -> ( model, Maybe Effect )
eventMap tree model event =
  case Debug.log "FormBuilder - EventMap" event of

    InputField_Updated id value ->
      let
        t = Debug.log "Updated" model
      in
        ( updateTree tree model event, Nothing )


type BulletTypes
  = NoBullet
  | AlphaBullet
  | NumericBullet

type SectionKinds
  = Header String String
  | Grid
  | List
  | Bullets BulletTypes

type alias SectionModel =
  { kind : SectionKinds
  , label : Maybe String
  }

type FieldTypes model
  = InputField (InputFieldModel model)
  | LabeledTextField (LabeledTextFieldModel)
  | RadioField (RadioFieldModel model)
  | BoolField (BoolFieldModel model)

type alias InputFieldModel model =
  { id : String
  , label : String
  , placeholder : String
  , get : model -> String
  , set : model -> String -> model
  }

type alias LabeledTextFieldModel =
  { label : String
  , text : String
  }

type alias RadioFieldModel model =
  { options : Set String
  , get : model -> Set String
  , set : model -> Set String -> model
  }

type alias BoolFieldModel model =
  { get : model -> Bool
  , set : model -> Bool -> model
  }


buildForm : MetaTree (FieldTypes model) SectionModel -> model -> Html Command
buildForm formDef model =
    formZipper formDef model

leafToForm : FieldTypes model -> model -> Html Command
leafToForm leaf model =
  case leaf of
    BoolField def ->
      div
        []
        [ Html.text <| "Bool Leaf " ++ " [" ++ (toString (def.get model)) ++ "]"
        ]

    InputField def ->
      UI.inputField
        { id = def.id
        , label = def.label
        , placeholder = def.placeholder
        , inputType = UI.TextField
        , value = (def.get model)
        , error = Nothing
        , onInput = InputField_Update def.id
        }

    LabeledTextField def ->
      div
        []
        [ Html.text <| "Labeled Text Leaf " ++ def.label ++ " [" ++ " -- " ++ "]"
        ]

    RadioField def ->
      div
        []
        [ Html.text <| "Radio Leaf " ++ (toString (List.length (Set.toList def.options))) ++ " [" ++ (toString (Set.toList (def.get model))) ++ "]"
        ]

branchToForm : Maybe SectionModel -> model -> List (Html Command) -> Html Command
branchToForm meta model children =
  case meta of
    Nothing -> div [] children

    Just branch ->
      let
        content = case branch.kind of
          Header imgSrc title ->
            Html.text <| "Header Branch: [" ++ (Maybe.withDefault "" branch.label) ++ "]"

          Grid ->
            Html.text <| "Grid Branch: [" ++ (Maybe.withDefault "" branch.label) ++ "]"
          
          List ->
            Html.text <| "List Branch: [" ++ (Maybe.withDefault "" branch.label) ++ "]"

          Bullets type_ ->
            Html.text <| "Bullets Branch: [" ++ (Maybe.withDefault "" branch.label) ++ "]"
          
      in
        div
          []
          [ content
          , div [] children
          ]

formZipper : MetaTree (FieldTypes model) SectionModel -> model -> Html Command
formZipper tree model =
  let
    applyZipper ((subtree, crumbs) as zipper) =
      -- case Debug.log "SubTree" subtree of
      case subtree of
        Leaf state ->
          leafToForm state model

        Branch (meta, subtrees) ->
          subtrees
          |> List.indexedMap
            (\index _ ->
              gotoIndex index zipper
              |> Maybe.map applyZipper
            )
          |> keepJusts
          |> branchToForm meta model
  in
    applyZipper (fromTree tree)

updateLeaf : FieldTypes model -> model -> Event -> model
updateLeaf leaf model event =
  case event of
    InputField_Updated id data ->
      case leaf of
        InputField def ->
          if def.id == id then
            def.set model data
          else
            model

        _ ->
          model

updateTree : MetaTree (FieldTypes model) SectionModel -> model -> Event -> model
updateTree tree model event =
  tree
  |> Example.MetaTree.toList
  |> List.foldr
    (\ leaf model ->
      updateLeaf leaf model event
    )
    model

-- updateZipper : MetaTree (FieldTypes model) SectionModel -> model -> event -> model
-- updateZipper tree model event =
--   let
--     applyZipper model_ ((subtree, crumbs) as zipper) =
--       case subtree of
--         Leaf state ->
--           updateLeaf state model_ event

--         Branch (meta, subtrees) ->
--           subtrees
--           |> List.indexedMap
--             (\index _ ->
--               gotoIndex index zipper
--               |> Maybe.map (applyZipper model_)
--             )
--           |> keepJusts
--           |> model
--   in
--     applyZipper (fromTree tree)

-- buildForm : SampleData -> MetaTree (FieldTypes SampleData) SectionModel -> Html command
-- buildForm model formDef =
--     formZipper model formDef

-- leafToForm : SampleData -> FieldTypes SampleData -> Html command
-- leafToForm model leaf =
--   case leaf of
--     BoolField def ->
--       div
--         []
--         [ Html.text <| "Bool Leaf " ++ " [" ++ (toString (def.get model)) ++ "]"
--         ]

--     InputField def ->
--       div
--         []
--         [ Html.text <| "Input Leaf " ++ def.label ++ " [" ++ (def.get model) ++ "]"
--         ]

--     LabeledTextField def ->
--       div
--         []
--         [ Html.text <| "Labeled Text Leaf " ++ def.label ++ " [" ++ " -- " ++ "]"
--         ]

--     RadioField def ->
--       div
--         []
--         [ Html.text <| "Radio Leaf " ++ (toString (List.length (Set.toList def.options))) ++ " [" ++ (toString (Set.toList (def.get model))) ++ "]"
--         ]

-- branchToForm : SampleData -> Maybe SectionModel -> List (Html command) -> Html command
-- branchToForm model meta children =
--   case meta of
--     Nothing -> div [] children

--     Just branch ->
--       let
--         content = case branch.kind of
--           Header imgSrc title ->
--             Html.text <| "Header Branch: [" ++ (Maybe.withDefault "" branch.label) ++ "]"

--           Grid ->
--             Html.text <| "Grid Branch: [" ++ (Maybe.withDefault "" branch.label) ++ "]"
          
--           List ->
--             Html.text <| "List Branch: [" ++ (Maybe.withDefault "" branch.label) ++ "]"

--           Bullets type_ ->
--             Html.text <| "Bullets Branch: [" ++ (Maybe.withDefault "" branch.label) ++ "]"
          
--       in
--         div
--           []
--           [ content
--           , div [] children
--           ]

-- formZipper : SampleData -> MetaTree (FieldTypes SampleData) SectionModel -> Html command
-- formZipper model tree =
--   let
--     applyZipper ((subtree, crumbs) as zipper) =
--       case Debug.log "SubTree" subtree of
--         Leaf state ->
--           leafToForm model state

--         Branch (meta, subtrees) ->
--           subtrees
--           |> List.indexedMap
--             (\index _ ->
--               gotoIndex index zipper
--               |> Maybe.map applyZipper
--             )
--           |> keepJusts
--           |> branchToForm model meta
--   in
--     applyZipper (fromTree tree)


-- companyNameGetter : SampleDetails -> String
-- companyNameGetter = .companyName

-- companyNameSetter : SampleDetails -> String -> SampleDetails
-- companyNameSetter 

-- servicesSetter : SampleData -> Set String -> SampleData
-- servicesSetter model data =
--   { model | services = data }



-- type alias SampleData =
--   { details : SampleDetails
--   , serviceDescription : SampleServiceDescription
--   }

-- type alias SampleDetails =
--   { companyName : String
--   , contactName : String
--   , emailAddress : String
--   -- , date : Date
--   , title : String
--   , telephone : String
--   }

-- type alias SampleServiceDescription =
--   { services : Set String
--   , servicesDescription : String
--   -- , dataTypes : Set String
--   -- , compliancePII : Bool
--   -- , compliancePHI : Bool
--   -- , compliancePCI : Bool
--   }

-- type alias Lens parentModel childModel =
--   { get : parentModel -> childModel
--   , set : parentModel -> childModel -> parentModel
--   }


-- type alias SectionModel parentModel childModel =
--   { label : String
--   , ordering : Maybe String
--   , kind : SectionKinds
--   , data : Lens parentModel childModel
--   -- , children : List subChildModel
--   }
-- type alias SectionModel parentModel childModel subChildModel =
--   { label : String
--   , ordering : Maybe String
--   , kind : SectionKinds
--   , data : Lens parentModel childModel
--   , children : List subChildModel
--   }


-- , Leaf <| RadioField
--   { label = "Services:"
--   , get = .services
--   , set = servicesSetter
--   }

-- formZipper tree =
--   let
--     applyZipper ((subtree, crumbs) as zipper) =
--       case Debug.log "SubTree" subtree of
--         Leaf state ->
--           Leaf state

--         Branch (meta, subtrees) ->
--           subtrees
--           |> List.indexedMap
--             (\index _ ->
--               gotoIndex index zipper
--               |> Maybe.map applyZipper
--             )
--           |> keepJusts
--           |> (\st -> ( meta, st ) )
--           |> Branch
--   in
--     applyZipper (fromTree tree)

-- detailsGetter : SampleData -> SampleDetails
-- detailsGetter = .details

-- detailsSetter : SampleData -> SampleDetails -> SampleData
-- detailsSetter model data =
--   { model | details = data }


-- contractorInformation : SampleData -> MetaTree FieldTypes (SectionModel parentModel childModel)
-- contractorInformation model =
--   Branch
--     ( Just
--       { label = "Contractor Information"
--       , ordering = Nothing
--       , kind = GridLayout
--       , data =
--         { get = .details
--         , set = (\ (model, data) -> { model | details = data } )
--         }
--       }
--     , [ Leaf <| InputField
--           { label = "Company Name:"
--           , data =
--             { get = .displayName
--             , set = (\ (model, data) -> { model | displayName = data } )
--             }
--           }
--       ]
--     )

-- sampleForm model =
--   [ Section
--     { label = "Contractor Information"
--     , ordering = Nothing
--     , kind = GridLayout
--     , data =
--       { get = .details
--       , set = (\ (model, data) -> { model | details = data } )
--       }
--     , children =
--       [ InputField
--         { label = "Company Name:"
--         , data =
--           { get = .displayName
--           , set = (\ (model, data) -> { model | displayName = data } )
--           }
--         }
--       , InputField
--         { label = "Contact Name:"
--         , data =
--           { get = .contactName
--           , set = (\ (model, data) -> { model | contactName = data } )
--           }
--         }
--       , InputField
--         { label = "Email Address:"
--         , data =
--           { get = .emailAddress
--           , set = (\ (model, data) -> { model | emailAddress = data } )
--           }
--         }
--       , InputField
--         { label = "Date:"
--         , data =
--           { get = .date
--           , set = (\ (model, data) -> { model | date = data } )
--           }
--         }
--       , InputField
--         { label = "Title:"
--         , data =
--           { get = .title
--           , set = (\ (model, data) -> { model | title = data } )
--           }
--         }
--       , InputField
--         { label = "Telephone:"
--         , data =
--           { get = .telephone
--           , set = (\ (model, data) -> { model | telephone = data } )
--           }
--         }
--       ]
--     }
--   ]

-- InputField
--   { label = "Company Name:"
--   , data =
--     { get = .displayName
--     , set = (\ (model, data) -> { model | displayName = data } )
--     }
--   }
-- , InputField
--   { label = "Contact Name:"
--   , data =
--     { get = .contactName
--     , set = (\ (model, data) -> { model | contactName = data } )
--     }
--   }
-- , InputField
--   { label = "Email Address:"
--   , data =
--     { get = .emailAddress
--     , set = (\ (model, data) -> { model | emailAddress = data } )
--     }
--   }
-- , InputField
--   { label = "Date:"
--   , data =
--     { get = .date
--     , set = (\ (model, data) -> { model | date = data } )
--     }
--   }
-- , InputField
--   { label = "Title:"
--   , data =
--     { get = .title
--     , set = (\ (model, data) -> { model | title = data } )
--     }
--   }
-- , InputField
--   { label = "Telephone:"
--   , data =
--     { get = .telephone
--     , set = (\ (model, data) -> { model | telephone = data } )
--     }
--   }