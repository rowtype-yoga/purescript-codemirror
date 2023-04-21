module Codemirror.Language where

import Prelude
import Codemirror.Types as CM
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Data.Nullable (Nullable)
import Prim.Row (class Union)
import Data.Int.Bits (or)

foreign import markdownSyntaxHighlighting ∷ Effect CM.Extension

foreign import syntaxTree :: CM.EditorState -> Effect CM.Tree

foreign import syntaxTreeAvailable :: CM.EditorState -> Effect Boolean

foreign import syntaxTreeAvailableUpTo :: CM.EditorPosition -> CM.EditorState -> Effect Boolean

foreign import iterateImpl :: forall args. { | args } -> CM.Tree -> Effect Unit

type Enter = EffectFn1 CM.SyntaxNodeRef Boolean

type IterateArgs =
  ( from :: CM.EditorPosition
  , to :: CM.EditorPosition
  , enter :: Enter
  , leave :: EffectFn1 CM.SyntaxNodeRef Unit
  , mode :: IterMode
  )

iterate :: forall r r_. Union r r_ IterateArgs => { enter :: Enter | r } -> CM.Tree -> Effect Unit
iterate = iterateImpl

newtype IterMode = IterMode Int

excludeBuffers :: IterMode
excludeBuffers = IterMode 1

includeAnonymous :: IterMode
includeAnonymous = IterMode 2

ignoreMounts :: IterMode
ignoreMounts = IterMode 4

ignoreOverlays :: IterMode
ignoreOverlays = IterMode 8

instance Semigroup IterMode where
  append (IterMode x) (IterMode y) = IterMode (x # or y)

