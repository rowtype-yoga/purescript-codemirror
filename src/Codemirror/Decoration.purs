module Codemirror.Decoration where

import Prelude
import Codemirror.Types as CM
import Effect (Effect)
import Foreign.Object (Object)
import Prim.Row (class Union)
import Data.Nullable (Nullable, toMaybe)
import Web.HTML.HTMLElement (HTMLElement)
import Foreign (Foreign)
import Web.Event.Internal.Types (Event)
import Unsafe.Coerce (unsafeCoerce)
import Data.Maybe (Maybe)
import Data.Nullable (toMaybe) as Nullable

foreign import decorationNone :: forall r. CM.RangeSet (CM.Decoration r)

type MarkDecorationSpec r =
  ( inclusive :: Boolean
  , inclusiveStart :: Boolean
  , inclusiveEnd :: Boolean
  , attributes :: Object String
  , class :: String
  , tagName :: String
  | r
  )

foreign import decorationMarkImpl :: forall r s. { | r } -> CM.Decoration s

decorationMark :: forall r r_ more. Union r r_ (MarkDecorationSpec more) => { | r } -> CM.Decoration more
decorationMark = decorationMarkImpl

foreign import decorationsFrom :: forall a. CM.StateField a -> Effect CM.Extension

foreign import decorationRange :: forall r. CM.EditorPosition -> CM.EditorPosition -> CM.Decoration r -> CM.Range (CM.Decoration r)

decorationRangeAt :: forall r. CM.EditorPosition -> CM.Decoration r -> CM.Range (CM.Decoration r)
decorationRangeAt pos = decorationRange pos pos

foreign import newWidgetImpl :: forall state a. state -> { | a } -> Effect (CM.PSWidget state)

newWidget
  :: forall state r r_
   . Union r r_
       ( eq :: CM.PSWidget state -> CM.PSWidget state -> Effect Boolean
       , ignoreEvent :: Event -> Effect Boolean
       , toDOM :: CM.EditorView -> Effect HTMLElement
       )
  => state
  -> { toDOM :: (CM.PSWidget state) -> CM.EditorView -> Effect HTMLElement | r }
  -> Effect (CM.PSWidget state)
newWidget = newWidgetImpl

foreign import getWidgetState :: forall a. CM.PSWidget a -> Effect a

foreign import setWidgetState :: forall a. a -> CM.PSWidget a -> Effect Unit

psWidgetToWidget :: forall a. CM.PSWidget a -> CM.Widget
psWidgetToWidget = unsafeCoerce

foreign import decorationSet :: forall r. Array (CM.Range (CM.Decoration r)) -> CM.DecorationSet r

foreign import sortedDecorationSet :: forall r. Array (CM.Range (CM.Decoration r)) -> CM.DecorationSet r

type DecorationWidgetSpec r =
  ( side :: Int
  , widget :: CM.Widget
  , block :: Boolean
  , inclusive :: Boolean
  | r
  )

foreign import decorationWidgetImpl :: forall r s. { | r } -> CM.Decoration s

decorationWidget
  :: forall r r_ more
   . Union r r_ (DecorationWidgetSpec more)
  => { widget :: CM.Widget
     | r
     }
  -> CM.Decoration more
decorationWidget = decorationWidgetImpl

foreign import decorationSpec :: forall r. CM.Decoration r -> { | r }

foreign import decorationReplaceImpl :: forall r s. { | r } -> CM.Decoration s

type ReplaceWidgetSpec r =
  ( inclusive :: Boolean
  , inclusiveStart :: Boolean
  , inclusiveEnd :: Boolean
  , widget :: CM.Widget
  , block :: Boolean
  | r
  )

decorationReplace
  :: forall r r_ more
   . Union r r_ (ReplaceWidgetSpec more)
  => { widget :: CM.Widget
     | r
     }
  -> CM.Decoration more
decorationReplace = decorationReplaceImpl

foreign import iterateRangeSet :: forall r. CM.RangeSet r -> Effect (CM.RangeCursor r)

foreign import nextRange :: forall r. CM.RangeCursor r -> Effect Unit

foreign import rangeCursorValueImpl :: forall r. CM.RangeCursor r -> Effect (Nullable r)

rangeCursorValue :: forall r. CM.RangeCursor r -> Effect (Maybe r)
rangeCursorValue = map toMaybe <<< rangeCursorValueImpl

foreign import rangeCursorFrom :: forall r. CM.RangeCursor r -> Effect CM.EditorPosition

foreign import rangeCursorTo :: forall r. CM.RangeCursor r -> Effect CM.EditorPosition

