module Codemirror.View where

import Prelude
import Codemirror.Types as CM
import Effect (Effect)
import Unsafe.Coerce (unsafeCoerce)

foreign import state :: CM.EditorView -> Effect CM.EditorState

foreign import stateField :: forall a. CM.EditorState -> CM.StateField a -> Effect a

foreign import selection :: CM.EditorState -> Effect CM.EditorSelection

foreign import ranges :: CM.EditorSelection -> Effect (Array CM.SelectionRange)

foreign import selectionRangeEmpty :: CM.SelectionRange -> Boolean

foreign import selectionFrom :: CM.EditorSelection -> Int

foreign import selectionTo :: CM.EditorSelection -> Int

foreign import dispatch :: CM.Transaction -> CM.EditorView -> Effect Unit

foreign import visibleRanges :: CM.EditorView -> Effect (Array (CM.Range CM.EditorPosition))

foreign import newViewPlugin
  :: forall a b. (CM.EditorView -> Effect a) -> { | b } -> Effect (CM.ViewPlugin a)

viewPluginToExtension :: forall a. CM.ViewPlugin a -> CM.Extension
viewPluginToExtension = unsafeCoerce

foreign import updateListenerOf :: (CM.ViewUpdate -> Effect Unit) -> CM.Extension