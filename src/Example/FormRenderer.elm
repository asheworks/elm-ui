module Example.FormRenderer exposing
  ( renderer
  )

import Example.FormBuilder exposing (..)

import Html exposing (..)

renderer : Sections branch ( DataFacts meta ) meta -> meta -> Maybe ( Html Command )
renderer node meta =
  Just <|
    case node of
      Branch id container mods_ _ ->
        let
          t = Debug.log "Section" container
        in
          div [] [ text <| "Section: " ++ (Maybe.withDefault "-" id) ]

      Leaf id leaf mods_ ->
        let
          id_ = Maybe.withDefault "" id
        in
          case leaf of

            Bool mods control ->
              let
                t = Debug.log "Bool" control
              in
                div [] [ text <| "Bool: " ++ id_ ]

            FileUpload mods control ->
              let
                t = Debug.log "FileUpload" control
              in
                div [] [ text <| "FileUpload: " ++ id_ ]

            Option mods values control ->
              let
                t = Debug.log "Options" control
              in
                div [] [ text <| "Options: " ++ id_ ]

            Text mods control ->
              let
                t = Debug.log "Text" control
              in
                div [] [ text <| "Text: " ++ id_ ]

toView meta tree =
  let
    applyZipper path depth index ( ( ( ( Tree node children ) as subTree ), crumbs ) as zipper ) =
      case node of
        Leaf id leaf mods ->
          let
            id_ = Maybe.withDefault "" id

            path_ = appendPath path id_
          in
            div [][ text path_ ]
          -- leafToForm zipper
        Branch id branch mods _ ->
          let
            id_ = Maybe.withDefault "" id

            path_ = appendPath path id_
          in
            children
              |> List.indexedMap
                  (\ index_ _ ->
                      goToChild index_ zipper
                        |> Maybe.map ( applyZipper path_ (depth + 1) index_ )
                  )
              |> keepJusts
              |> div []
              -- |> branchToForm zipper ...


  in
    applyZipper "" 0 0 ( tree, [] )