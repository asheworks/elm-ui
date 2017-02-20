module Example.MetaTree exposing (..)

--

type MetaTree a meta
  = Branch (Maybe meta, (List (MetaTree a meta)))
  | Leaf a


toList : MetaTree a meta -> List a 
toList tree = 
  case tree of 
    Leaf a -> 
      [a]
      
    Branch (meta, subtrees) -> 
      List.concatMap toList subtrees


type alias MetaCrumb a meta =
  { left : List (MetaTree a meta)
  , right : List (MetaTree a meta)
  , meta : Maybe meta
  }


type alias Zipper a meta = (MetaTree a meta, List (MetaCrumb a meta))


fromTree : MetaTree a meta -> Zipper a meta
fromTree t = (t, [])


goUp : Zipper a meta -> Maybe (Zipper a meta)
goUp (subtree, branches) = 
  case branches of 
    [] ->
      Nothing
      
    {left, right} :: bs -> 
      let
        meta = case subtree of
          Branch (meta, _) -> meta
          _ -> Nothing
      in
        Just (Branch (meta, (left ++ [subtree] ++ right)), bs)


-- goUp : Zipper a -> Maybe (Zipper a)
-- goUp ( tree, breadcrumbs ) =
--     case breadcrumbs of
--         [] ->
--             Nothing
--         (Context datum before after) :: bs ->
--             Just ( Tree datum (before ++ [ tree ] ++ after), bs )

        


goLeft : Zipper a meta -> Maybe (Zipper a meta)
goLeft (subtree, branches) =
  case branches of 
    [] ->
      Nothing
      
    {left, right} :: bs ->
      case List.reverse left of
        [] ->
          Nothing
        
        tree_ :: rest ->
          let
            meta = case subtree of
              Branch (meta, _) -> meta
              _ -> Nothing

            crumbs = (MetaCrumb (List.reverse rest) (subtree :: right) meta) :: bs
          in
            Just
              ( tree_, crumbs )
              -- , ( MetaCrumb
              --     { left = List.reverse rest
              --     , right = subtree :: right
              --     , meta = meta
              --     }
              --   )
              --   -- :: bs
              -- )

      -- let
      --   q = Debug.log "META" meta
      --   t = Debug.log "LEFT" left
      --   u = Debug.log "RIGHT" right
      --   v = Debug.log "BS" bs
      -- in
      --   Just (Branch (meta, (left ++ [subtree] ++ right)), bs)

-- goLeft : Zipper a -> Maybe (Zipper a)
-- goLeft ( tree, breadcrumbs ) =
--     case breadcrumbs of
--         [] ->
--             Nothing

--         (Context datum before after) :: bs ->
--             case List.reverse before of
--                 [] ->
--                     Nothing

--                 tree_ :: rest ->
--                     Just ( tree_, (Context datum (List.reverse rest) (tree :: after)) :: bs )


zipperMap : (Zipper a meta -> a -> b) -> MetaTree a meta -> MetaTree b meta
zipperMap f tree =
  let
    applyZipper ((subtree, crumbs) as zipper) =
      case subtree of
        Leaf state ->
          Leaf (f zipper state)
        
        Branch (meta, subtrees) ->
          subtrees
          |> List.indexedMap
            (\index _ ->
              gotoIndex index zipper
              |> Maybe.map applyZipper
            )
          |> keepJusts
          |> (\st -> ( meta, st ) )
          |> Branch
  in
    applyZipper (fromTree tree)


zipperUpdate : Zipper a meta -> (a -> a) -> MetaTree a meta -> MetaTree a meta
zipperUpdate zipper f tree = 
  zipperMap (\z a -> if z == zipper then f a else a) tree


gotoIndex : Int -> Zipper a meta -> Maybe (Zipper a meta)
gotoIndex index (tree, bs) = 
  case tree of
    Leaf _ ->
      Nothing
      
    Branch (meta, subtrees) ->
      case nth index subtrees of 
        Nothing ->
          Nothing 
          
        Just newTree ->
          let 
              newCrumb = 
                { left  = List.take index subtrees
                , right = List.drop (index + 1) subtrees
                , meta = meta
                }
          in 
              Just (newTree, newCrumb :: bs)
     
     
nth : Int -> List a -> Maybe a 
nth index list = 
  if 
    index < 0 
  then 
    Nothing 
  else
    list
    |> List.drop index
    |> List.head
  

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