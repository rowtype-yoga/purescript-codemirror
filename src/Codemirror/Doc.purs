module Codemirror.Doc where

import Prelude

import Codemirror.Types as CM
import Effect (Effect)

foreign import toString :: CM.Doc -> Effect String

foreign import sliceString :: CM.EditorPosition -> CM.EditorPosition -> CM.Doc -> Effect String