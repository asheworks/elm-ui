module UI.Grid exposing
  ( ThemeCssClasses(..)
  )

{-| Grid control provides layout a structure for row or column orientations using flexbox
-}
 type ThemeCssClasses
  = Theme_Grid_Wrapper
  | Theme_Grid

type alias GridModel =
  { id : String

  }

type Grid
  = Row
  | Column

toHtml : Html command
toHtml =
  div
    [ theme.class
    
    ]