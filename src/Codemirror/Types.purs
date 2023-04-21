module Codemirror.Types where

import Prelude
import Web.HTML (HTMLElement)
import Data.Nullable (Nullable)
import Effect.Uncurried (EffectFn1)
import Effect (Effect)

foreign import data Keymap ∷ Type

foreign import data EditorState ∷ Type

newtype EditorPosition = EditorPosition Int

derive newtype instance Eq EditorPosition
derive newtype instance Ord EditorPosition

foreign import data Doc ∷ Type

foreign import data EditorSelection ∷ Type

foreign import data SelectionRange ∷ Type

foreign import data Extension ∷ Type

foreign import data Command ∷ Type

foreign import data KeyBinding ∷ Type

foreign import data EditorView ∷ Type

foreign import data StateField ∷ Type -> Type

foreign import data StateEffect ∷ Type -> Type

foreign import data StateEffectType ∷ Type -> Type

foreign import data ChangeSet ∷ Type

foreign import data ChangeDesc ∷ Type

foreign import data Transaction ∷ Type

foreign import data Decoration :: Row Type -> Type

foreign import data ViewPlugin :: Type -> Type

type ViewUpdate =
  { view :: EditorView
  , state :: EditorState
  , transactions :: Array Transaction
  , changes :: ChangeSet
  , startState :: EditorState
  , viewportChanged :: Boolean
  , heightChanged :: Boolean
  , geometryChanged :: Boolean
  , focusChanged :: Boolean
  , docChanged :: Boolean
  , selectionSet :: Boolean
  }

type Range a = { from :: a, to :: a }

foreign import data RangeSet :: Type -> Type

foreign import data RangeCursor :: Type -> Type

foreign import data WidgetType ∷ Type
foreign import data PSWidget ∷ Type -> Type
foreign import data Widget ∷ Type

foreign import data Tree ∷ Type

type SyntaxNodeRef =
  { from :: EditorPosition
  , to :: EditorPosition
  , type :: NodeType
  , name :: SyntaxNodeName
  , tree :: Nullable Tree
  , node :: SyntaxNode
  , matchContext :: Array String -> Boolean
  }

newtype SyntaxNodeName = SyntaxNodeName String

derive newtype instance Eq SyntaxNodeName
derive newtype instance Ord SyntaxNodeName

foreign import data NodeType ∷ Type

foreign import data SyntaxNode ∷ Type

type DecorationSet r = RangeSet (Decoration r)

type EditorViewArgs =
  ( extensions ∷ Array Extension
  , state ∷ EditorState
  , parent ∷ HTMLElement
  )

