module Example.FormBuilder exposing
  ( Command(..)
  , Event(..)
  , Effect(..)
  , BulletTypes(..)
  , SectionKinds(..)
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

import Dict exposing (..)
import Set exposing (..)

-- import Date exposing (..)
import Html exposing (..)

--

import UI as UI
-- import Example.MetaTree exposing (..)
import MultiwayTree exposing (..)
import MultiwayTreeZipper exposing (..)


--

type Command
  = BoolField_Update String Bool
  | InputField_Update String String
  | RadioField_Update String (Int, String)

type Event
  = BoolField_Updated String Bool
  | InputField_Updated String String
  | RadioField_Updated String (Int, String)

type Effect
  = None


commandMap : MetaTree (FieldTypes model) SectionKinds -> model -> Command -> Event
commandMap tree model command =
  case Debug.log "FormBuilder - CommandMap" command of
    
    BoolField_Update id value ->
      BoolField_Updated id value

    InputField_Update id value ->
      InputField_Updated id value
    
    RadioField_Update id value ->
      RadioField_Updated id value


updateTreeById : MetaTree (FieldTypes model) SectionKinds -> String -> model -> (FieldTypes model -> model) -> model
updateTreeById tree id model leafMap =
  tree
  |> Example.MetaTree.toList
  |> List.foldr
    (\ leaf model ->
      case leaf of
        BoolField def ->
          if def.id == id then
            leafMap leaf
          else
             model

        InputField def ->
          if def.id == id then  
            leafMap leaf
          else
            model

        RadioField def ->
          if def.id == id then  
            leafMap leaf
          else
            model

        _ ->
          model
    )
    model


eventMap : MetaTree (FieldTypes model) SectionKinds -> model -> Event -> ( model, Maybe Effect )
eventMap tree model event =
  let
    model_ = case Debug.log "FormBuilder - EventMap" event of

    BoolField_Updated id value ->
      updateTreeById tree id model
        (\ leaf ->
          case leaf of
            BoolField def -> def.set model value
            _ -> model
        )

    InputField_Updated id value ->
      updateTreeById tree id model
        (\ leaf ->
          case leaf of
            InputField def -> def.set model value
            _ -> model
        )

    RadioField_Updated id (index, value) ->
      updateTreeById tree id model
        (\ leaf ->
          case leaf of
            RadioField def -> --def.set model value
              if Set.member value (def.get model) then
                def.set model <| Set.remove value (def.get model)
              else
                def.set model <| Set.insert value (def.get model)
            _ -> model
        )
  in
    ( model_, Nothing )


type BulletTypes
  = AlphaBullet
  | NumericBullet


type alias HeaderModel =
  { id : String
  , imgSrc : String
  , title : String
  }


type alias GridModel =
  { title : String
  }


type alias ListModel =
  { title : String
  }


type alias BulletsModel =
  { title : String
  , type_ : BulletTypes
  , show : Bool
  }


type SectionKinds
  = Header HeaderModel
  | Grid GridModel
  | List ListModel
  | Bullets BulletsModel


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
  { id : String
  , options : Dict String String
  , get : model -> Set String
  , set : model -> Set String -> model
  }


type alias BoolFieldModel model =
  { id : String
  , get : model -> Bool
  , set : model -> Bool -> model
  }


buildForm : MetaTree (FieldTypes model) SectionKinds -> model -> Html Command
buildForm formDef model =
    formZipper formDef model


leafToForm : Zipper (FieldTypes model) SectionKinds -> FieldTypes model -> model -> Html Command
leafToForm ctx leaf model =
  case leaf of
    BoolField def ->
      UI.yesNoField
        { id = def.id
        , yesLabel = "Yes"
        , noLabel = "No"
        , value = (def.get model)
        , error = Nothing
        , onChange = BoolField_Update def.id
        }


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
      UI.labelField
        { id = ""
        , label = def.label
        , value = def.text
        }


    RadioField def ->
      UI.checkboxControl
        { id = def.id
        , values = def.options
          |> Dict.toList
          |> List.map
            (\ (key, value) ->
                { key = key
                , value = value
                , checked = Set.member key (def.get model)
                , error = Nothing
                }
            )
        , error = Nothing
        , onSelect = RadioField_Update def.id
        }


bulletString : Zipper (FieldTypes model) SectionKinds -> String
bulletString ctx =
  let
    countPrevZipper count ((subtree, crumbs) as zipper) =
      case goLeft zipper of
        Nothing -> count
        Just prev ->
          countPrevZipper (count + 1) prev

    bulletStringZipper ((subtree, crumbs) as zipper) =
      case subtree of
        Leaf _ -> ""
        Branch ( meta, subtrees ) ->
          case meta of
            Nothing -> ""
            Just branch ->
              case branch of
                Bullets def ->
                  let
                    countPrev = countPrevZipper 0 zipper
                  in
                    case def.type_ of
                      AlphaBullet -> "A" ++ (toString countPrev) -- ++ (toString count)
                      NumericBullet -> "N" ++ (toString countPrev)-- ++ (toString count)

                _ -> ""

    -- countPrev = countPrevZipper 0 ctx
    bulletString = bulletStringZipper ctx

    t = Debug.log "bulletString" bulletString

    applyZipper depth label ((subtree, crumbs) as zipper) =
      let
        -- label_ = ""
        -- label_ = branchString zipper (label ++ "-" ++ (toString depth))
        label_ = label ++ " - " ++ (bulletStringZipper zipper)-- (label ++ "-" ++ (toString depth))
      in
        --case goUp zipper of
       case goUp zipper of
          Nothing -> label
          Just parent ->
            -- let
            --   -- label_ = ""
            --   -- label_ = branchString zipper (label ++ "-" ++ (toString depth))
            --   label_ = label ++ " - " ++ (bulletStringZipper parent)-- (label ++ "-" ++ (toString depth))
            -- in
              applyZipper (depth + 1) label_ parent
  in
    applyZipper 0 "" ctx



  -- let
  --   applyZipper depth count ((subtree, crumbs) as zipper) =
  --     let

  --     in

  -- in
  --   applyZipper 0 0 ctx

-- bulletString : Zipper (FieldTypes model) SectionKinds -> String
-- bulletString ctx =
--   let
--     branchString ((subtree, crumbs) as zipper) branch label =
--       case branch of
--         Bullets def ->
--           let
--             count = bulletAlphaCount zipper
--           in
--             case def.type_ of
--               AlphaBullet -> label ++ "A" ++ (toString count)
--               NumericBullet -> label ++ "1" ++ (toString count)

--         _ -> label

--     applyZipper depth label ((subtree, crumbs) as zipper) =
--       let
--         label_ = case subtree of
--           Leaf _ -> label
--           Branch ( meta, subtrees ) ->
--             case meta of
--               Nothing -> label
--               Just branch ->
--                 branchString zipper branch (label ++ "-" ++ (toString depth))
--       in
--         --case goUp zipper of
--         case goLeft zipper of
--           Nothing -> label
--           Just parent ->
--               applyZipper (depth + 1) label_ parent
--   in
--     applyZipper 0 ("*" ++ (branchString ctx)) ctx

-- let
--   t = Debug.log "Parent" parent
--   -- label_ = case parent of
--   --   Leaf _ -> label
--   --   Branch ( meta, subtrees ) ->
--   --     let
--   --       t = Debug.log "Parent" meta
--   --     in
--   --       toString depth

--   label_ = toString depth
  
-- in

-- bulletString : Zipper (FieldTypes model) SectionKinds -> String
-- bulletString ctx =
--   let
--     applyZipper label ((subtree, crumbs) as zipper) =
--       -- case Debug.log "bulletString SUB" subtree of
--       case subtree of
--         Leaf _ -> label
--         Branch (meta, subtrees) ->
--           let
--             label_ =
--               case meta of
--                 Nothing -> ""
--                 Just branch ->
--                   case branch of
--                     Bullets def ->
--                       case Debug.log "bulletString branch" def.type_ of
--                         AlphaBullet -> "A -"
--                         NumericBullet -> "1 -"
--                     _ -> ""
--           in
--             case goUp zipper of
--               Nothing -> label
--               Just parent ->
--                 applyZipper (label_ ++ label) parent

--   in
--     applyZipper "" ctx

branchToForm : Zipper (FieldTypes model) SectionKinds -> Maybe SectionKinds -> model -> List (Html Command) -> Html Command
branchToForm ctx meta model children =
  case meta of
    Nothing -> div [] children

    Just branch ->
      -- let
        -- t = Debug.log "Bullets" bullets
        -- u = Debug.log "state" state
      -- in
        case branch of

          Header def ->
            UI.formControl
              { id = def.id
              , header = Just
                [ Html.text <| "Header Branch: [" ++ def.title ++ "]"
                ]
              , section = Just children
              , aside = Nothing
              , footer = Nothing
              }

          Grid def ->
            div
              []
              [ Html.text <| "Grid Branch: [" ++ def.title ++ "]"
              , div [] children
              ]
          
          List def ->
            div
              []
              [ Html.text <| "List Branch: [" ++ def.title ++ "]"
              , div [] children
              ]

          Bullets def ->
            div
              []
              [ span
                  []
                  [ Html.text <| (bulletString ctx) ++ "  "
                  -- [ Html.text <| (bulletString state bullets) ++ "  "
                  -- [ Html.text "  "
                  ]
              , span
                  []
                  [ Html.text def.title
                  ]
              , div
                  []
                  children
              ]

formZipper : MetaTree (FieldTypes model) SectionKinds -> model -> Html Command
formZipper tree model =
  let
    applyZipper depth index ((subtree, crumbs) as zipper) =
      case subtree of

        Leaf meta ->
          leafToForm zipper meta model

        Branch (meta, subtrees) ->
            subtrees
            |> List.indexedMap
              (\index_ _ ->
                gotoIndex index_ zipper
                |> Maybe.map (applyZipper (depth + 1) index_)
              )
            |> keepJusts
            |> branchToForm zipper meta model

  in
    applyZipper 0 0 (fromTree tree)


-- branchToForm : BulletDepthState -> List (Int, Int, BulletTypes) -> Maybe SectionKinds -> model -> List (Html Command) -> Html Command
-- branchToForm state bullets meta model children =
--   case meta of
--     Nothing -> div [] children

--     Just branch ->
--       let
--         t = Debug.log "Bullets" bullets
--         -- u = Debug.log "state" state
--       in
--         case branch of

--           Header def ->
--             UI.formControl
--               { id = def.id
--               , header = Just
--                 [ Html.text <| "Header Branch: [" ++ def.title ++ "]"
--                 ]
--               , section = Just children
--               , aside = Nothing
--               , footer = Nothing
--               }

--           Grid def ->
--             div
--               []
--               [ Html.text <| "Grid Branch: [" ++ def.title ++ "]"
--               , div [] children
--               ]
          
--           List def ->
--             div
--               []
--               [ Html.text <| "List Branch: [" ++ def.title ++ "]"
--               , div [] children
--               ]

--           Bullets def ->
--             div
--               []
--               [ span
--                   []
--                   [ Html.text <| (bulletString state bullets) ++ "  "
--                   ]
--               , span
--                   []
--                   [ Html.text def.title
--                   ]
--               , div
--                   []
--                   children
--               ]

-- type alias BulletTypeState =
--   { numeric : Int
--   , alpha : Int
--   }

-- type alias BulletTypeContext =
--   { depth : Int
--   , index : Int
--   , type_ : BulletTypes
--   }

-- type BulletDepthState = Dict Int BulletTypeState

-- incBulletDepth : Int -> BulletDepthState -> Maybe SectionKinds -> BulletDepthState
-- incBulletDepth depth state meta =
--   case meta of
--     Nothing -> state
--     Just branch ->
--       case branch of
--         Bullets def ->
--           let
--             (get, set) = case def.type_ of
--               NoBullet -> (\_ -> 0) (\ (state_, value) -> state_ )
--               AlphaBullet -> .alpha (\ (state_, value) -> { state_ | alpha = value + 1 } )
--               NumericBullet -> .numeric (\ (state_, value) -> { state_ | numeric = value + 1 } )

--             update state = set <| get state
--           in
--             state
--             |> Dict.update depth (Maybe.map update)

--         _ -> state

-- appendContext : Int -> Int -> List BulletTypeContext -> Maybe SectionKinds -> List BulletTypeContext
-- appendContext depth index context meta =
--   List.append context <|
--     case meta of
--       Nothing -> []
--       Just branch ->
--           case branch of
--             Bullets def ->
--               let
--                 ctx : BulletTypeContext 
--                 ctx =
--                   { depth = depth
--                   , index = index
--                   , type_ = def.type_
--                   }
--               in
--                 [ ctx ]
            
--             _ -> []


-- bulletString : Dict Int BulletTypeState -> List (Int, Int, BulletTypes) -> String
-- bulletString state bullets =
--   List.map
--     (\ (depth, index, bullet) ->

--       let
--         state_ =
--           Maybe.withDefault
--             { alpha = 0
--             , numeric = 0
--             }
--             <| Dict.get depth state

--         t = Debug.log "State" state_
--       in
--         case bullet of

--           NoBullet -> ""

--           AlphaBullet ->
          
--             "A1 (" ++ (toString state_.alpha) ++ " -- " ++ (toString depth) ++ "-" ++ (toString index) ++ ")"

--           NumericBullet ->
            
--             "1 (" ++ (toString state_.numeric) ++ " -- "  ++ (toString depth) ++ "-" ++ (toString index) ++ ")"

--     )
--     bullets
--   |> String.concat

-- applyZipper state depth index bullets ((subtree, crumbs) as zipper) =


-- formMapper : MetaTree (FieldTypes model) SectionKinds -> model -> Html Command
-- formMapper tree model =
--   let
--     applyMap

-- type alias FormZipperState =
--   { bulletTypeStateByDepth : Dict Int BulletTypeState }



-- formZipper : MetaTree (FieldTypes model) SectionKinds -> model -> Html Command
-- formZipper tree model =
--   let
--     -- bulletState =
--     --   { numeric = Dict.empty
--     --   , alpha = Dict.empty
--     --   }

--     -- applyZipper
--     -- applyZipper : 
--     applyZipper depth index ((subtree, crumbs) as zipper) =
--       case subtree of

--         Leaf meta ->
--           leafToForm meta model

--         Branch (meta, subtrees) ->
--           -- let
--           --   -- state_ = updateState depth index state meta
--           --   bullets_ = appendBullet depth index bullets meta
--           -- in
--             subtrees
--             |> List.indexedMap
--               (\index_ _ ->
--                 gotoIndex index zipper
--                 |> Maybe.map (applyZipper (depth + 1) index_)
--                 -- |> Maybe.map (applyZipper state (depth + 1) index_ bullets_)
--               )
--             |> keepJusts
--             |> branchToForm meta model
--             -- |> branchToForm state bullets_ meta model

--   in
--     applyZipper 0 0 (fromTree tree)


-- type alias HtmlBulletZipper =
--   { state : Dict Int BulletState
--   , html : Html Command
--   }
  
-- formZipper : MetaTree (FieldTypes model) SectionKinds -> model -> Html Command
-- formZipper tree model =
--   let

--     applyZipper state depth index bullets ((subtree, crumbs) as zipper) =
--       case subtree of

--         Leaf meta ->
--           let
--             html_ = leafToForm meta model
--           in
--             { state = state
--             , html = html_
--             }

--         Branch (meta, subtrees) ->
--           let
--             state_ = updateState depth index state meta
--             bullets_ = appendBullet depth index bullets meta
--             html_ =
--               subtrees
--               |> List.indexedMap
--                 (\index _ ->
--                   gotoIndex index zipper
--                   |> Maybe.map (applyZipper state_ (depth + 1) index bullets_)
--                 )
--               |> keepJusts
--               |> branchToForm state_ bullets_ meta model
--           in
--             { state = state_
--             , html = html_
--             }
--             -- ( state_, bullets_, html_ )
--   in
--     (applyZipper Dict.empty 0 0 [] (fromTree tree)).html


--   -- in
--   --   applyZipper Dict.empty 0 0 [] (fromTree tree)
