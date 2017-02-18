module Example.Tree exposing (..)

--

type Tree a
  = Branch (List (Tree a))
  | Leaf a


toList : Tree a -> List a 
toList tree = 
  case tree of 
    Leaf a -> 
      [a]
      
    Branch subtrees -> 
      List.concatMap toList subtrees


type alias Crumb a =
  { left : List (Tree a)
  , right : List (Tree a)
  }


type alias Zipper a = (Tree a, List (Crumb a))


fromTree : Tree a -> Zipper a 
fromTree t = (t, [])


goUp : Zipper a -> Maybe (Zipper a)
goUp (subtree, branches) = 
  case branches of 
    [] ->
      Nothing
      
    {left, right} :: bs -> 
      Just (Branch (left ++ [subtree] ++ right), bs)


zipperMap : (Zipper a -> a -> b) -> Tree a -> Tree b
zipperMap f tree =
  let
    applyZipper ((subtree, crumbs) as zipper) =
      case subtree of
        Leaf state ->
          Leaf (f zipper state)
        
        Branch subtrees ->
          subtrees
          |> List.indexedMap
            (\index _ ->
              gotoIndex index zipper
              |> Maybe.map applyZipper
            )
          |> keepJusts
          |> Branch
  in
    applyZipper (fromTree tree)


zipperUpdate : Zipper a -> (a -> a) -> Tree a -> Tree a
zipperUpdate zipper f tree = 
  zipperMap (\z a -> if z == zipper then f a else a) tree


gotoIndex : Int -> Zipper a -> Maybe (Zipper a)
gotoIndex index (tree, bs) = 
  case tree of
    Leaf _ ->
      Nothing
      
    Branch subtrees ->
      case nth index subtrees of 
        Nothing ->
          Nothing 
          
        Just newTree ->
          let 
              newCrumb = 
                { left  = List.take index subtrees
                , right = List.drop (index + 1) subtrees
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