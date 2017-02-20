module Example.FormBuilder exposing
  ( Command(..)
  , Event(..)
  , Effect(..)
  , BulletTypes(..)
  , SectionKinds(..)
  , Branches(..)
  , Leafs(..)
  , InputFieldModel
  , LabeledTextFieldModel
  , RadioFieldModel
  , BoolFieldModel
  , commandMap
  , eventMap
  , buildForm
  , leafToForm
  , branchToForm
  )

import Dict exposing (..)
import Set exposing (..)
import Char exposing (..)

-- import Date exposing (..)
import Html exposing (..)

--

import UI as UI
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


commandMap : Branches model -> model -> Command -> Event
commandMap tree model command =
  case Debug.log "FormBuilder - CommandMap" command of
    
    BoolField_Update id value ->
      BoolField_Updated id value

    InputField_Update id value ->
      InputField_Updated id value
    
    RadioField_Update id value ->
      RadioField_Updated id value


updateTreeById : Tree (SectionKinds model) -> String -> model -> (Leafs model -> model) -> model
updateTreeById tree id model leafMap =
  tree
  |> flatten
  |> List.foldr
    (\ datum model ->
      case Debug.log "UPDATE TREE" datum of

        Branch _ -> model
        
        Leaf leaf ->

          case Debug.log "UPDATE LEAF" leaf of

            LabeledTextField _ -> model

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
    ) model


eventMap : Branches model -> model -> Event -> ( model, Maybe Effect )
eventMap root model event =
  let
    tree = toTree root
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

type Branches model
  = Header HeaderModel (List (SectionKinds model))
  | Grid GridModel (List (SectionKinds model))
  | List ListModel (List (SectionKinds model))
  | Bullets BulletsModel (List (SectionKinds model))

type Leafs model
  = InputField (InputFieldModel model)
  | LabeledTextField LabeledTextFieldModel
  | RadioField (RadioFieldModel model)
  | BoolField (BoolFieldModel model)

type SectionKinds model
  = Branch (Branches model)
  | Leaf (Leafs model)

toTree : Branches model -> Tree (SectionKinds model)
toTree root =
  let

    zipper : SectionKinds model -> Tree (SectionKinds model)
    zipper node =
      case node of

        Leaf leaf -> Tree node []

        Branch branch ->
          let
            children = case branch of
            Header _ children -> children
            Grid _ children -> children
            List _ children -> children
            Bullets _ children -> children
          in
            children
            |> List.map (\ child ->
                zipper child
              )
            |> Tree node

  in
    zipper <| Branch root
          

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


buildForm : Branches model -> model -> Html Command
buildForm formDef model =
  let
    applyZipper depth index ((subtree, crumbs) as zipper) =

      case subtree of

        Tree datum subtrees ->

          case datum of

            Leaf leaf ->
              leafToForm zipper leaf model

            Branch branch ->

             subtrees
              |> List.indexedMap
                (\index_ _ ->
                  goToChild index_ zipper
                  |> Maybe.map (applyZipper (depth + 1) index_)
                )
              |> keepJusts
              |> branchToForm zipper branch model
  in
    applyZipper 0 0 ( toTree formDef, [] )

leafToForm : Zipper (SectionKinds model) -> Leafs model -> model -> Html Command
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


bulletString : Zipper (SectionKinds model) -> String
bulletString ctx =
  let
    countPrevZipper ((alpha, numeric) as count) ((subtree, crumbs) as zipper) =
      case goLeft zipper of
        Nothing -> count
        Just ((subtree_, crumbs_) as prev) ->
          let
            count_ = case subtree_ of
              Tree datum _ ->

                case datum of
                  Branch branch ->

                    case branch of
                      Bullets def _ ->

                        case def.type_ of
                          AlphaBullet -> (alpha + 1, numeric)
                          NumericBullet -> (alpha, numeric + 1)

                      _ -> count

                  _ -> count
            
          in
            countPrevZipper count_ prev

    bulletStringZipper depth ((subtree, crumbs) as zipper) =

      case subtree of
        Tree datum _ ->

          case datum of
            Branch branch ->

              case branch of
                Bullets def _ ->
                  let
                    (alpha, numeric) = countPrevZipper (0, 0) zipper
                  in
                    case def.type_ of
                      AlphaBullet -> String.fromChar <| fromCode (alpha + 65)-- "A" ++ (toString countPrev) -- ++ (toString count)
                      NumericBullet -> (toString <| numeric + 1)-- ++ (toString count)
                
                _ -> ""

            _ -> ""

    applyZipper depth label ((subtree, crumbs) as zipper) =
      let
        label_ = (bulletStringZipper depth zipper) ++
          if String.length label == 0 then
            ""
          else
            "." ++ label
      in
        case goUp zipper of
          Nothing -> label
          Just parent ->
              applyZipper (depth + 1) label_ parent
  in
    applyZipper 0 "" ctx


branchToForm : Zipper (SectionKinds model) -> Branches model -> model -> List (Html Command) -> Html Command
branchToForm zipper branch model children =
  let
    ( subtree, crumbs ) = zipper
  in
    case branch of
      Header def _ ->
        UI.formControl
          { id = def.id
          , header = Just
            [ Html.text <| def.title
            ]
          , section = Just children
          , aside = Nothing
          , footer = Nothing
          }

      Grid def _ ->
        div
          []
          [ Html.text <| "Grid: [" ++ def.title ++ "]"
          , div [] children
          ]
      
      List def _ ->
        div
          []
          [ Html.text <| "List: [" ++ def.title ++ "]"
          , div [] children
          ]

      Bullets def _ ->
        div
          []
          [ span
              []
              [ Html.text <| (bulletString zipper) ++ "  "
              ]
          , span
              []
              [ Html.text def.title
              ]
          , div
              []
              children
          ]

keepJusts : List (Maybe a) -> List a
keepJusts list = 
  case list of 
    [] ->
      []
    mx :: xs ->
      case mx of 
        Nothing ->
          keepJusts xs
          
        Just x ->
          x :: keepJusts xs
