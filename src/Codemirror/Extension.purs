module Codemirror.Extension where

import Codemirror.Types
import Prelude
import Unsafe.Coerce

import Codemirror.Types (Extension)
import Codemirror.Types as CM
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)

foreign import keymapOfImpl
  :: Array
       { key :: String
       , preventDefault :: Boolean
       , run :: EffectFn1 CM.EditorView Boolean
       }
  -> Extension

keymapOf
  :: Array
       { key :: String
       , preventDefault :: Boolean
       , run :: EditorView -> Effect Boolean
       }
  -> Extension
keymapOf opts = keymapOfImpl
  ( opts <#> \opt -> opt
      { run = mkEffectFn1 opt.run
      }
  )

underlineSelection :: CM.EditorView -> Effect Boolean
underlineSelection view = pure true
