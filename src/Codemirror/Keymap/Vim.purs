module Codemirror.Keymap.Vim where

import Codemirror.Types as CM
import Effect (Effect)

foreign import vim ∷ Effect CM.Extension
