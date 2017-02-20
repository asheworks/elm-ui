module Themes.Default.YesNo exposing
  ( css
  )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import UI.YesNo exposing (..)

css themeNamespace =
  (stylesheet << namespace themeNamespace.name)
    [ (.) Theme_Wrapper
      [ displayFlex
      , flexDirection row
      ]
    , (.) Theme_Field
      [
      ]
    , (.) Theme_Button
      [
      ]
    , (.) Theme_Button_Selected
      [
      ]
    , (.) Theme_YesButton
      [
      ]
    , (.) Theme_NoButton
      [
      ]
    , (.) Theme_Error
      [
      ]
    ]