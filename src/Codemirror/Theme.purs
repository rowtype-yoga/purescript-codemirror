module Codemirror.Theme where

import Prelude

import Web.HTML (HTMLElement)
import Foreign (Foreign)
import Codemirror.Types as CM

foreign import baseTheme :: forall a. a -> CM.Extension

