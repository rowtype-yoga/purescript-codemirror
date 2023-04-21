module Codemirror where

import Codemirror.Types as CM
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row (class Union)
import Data.Unit (Unit)

foreign import defaultKeymap ∷ CM.Keymap
foreign import createEditorStateImpl ∷ ∀ args. EffectFn1 args CM.EditorState
foreign import keymapOfImpl ∷ EffectFn1 CM.Keymap CM.Extension
foreign import newEditorViewImpl ∷ ∀ args. EffectFn1 args CM.EditorView
foreign import basicSetup ∷ CM.Extension
foreign import lineWrapping ∷ CM.Extension

createEditorState ∷ ∀ args. args → Effect CM.EditorState
createEditorState = runEffectFn1 createEditorStateImpl

newEditorView
  ∷ ∀ args args_
  . Union args args_ CM.EditorViewArgs
  ⇒ { | args }
  → Effect CM.EditorView
newEditorView = runEffectFn1 newEditorViewImpl

foreign import destroy ∷ CM.EditorView → Effect Unit

