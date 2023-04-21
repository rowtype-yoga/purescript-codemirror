module Codemirror.State where

import Prelude
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn1, mkEffectFn2, runEffectFn1, runEffectFn2)
import Data.Function.Uncurried (Fn1, Fn2, mkFn1, mkFn2)
import Codemirror.Types as CM
import Effect (Effect)
import Untagged.Union (UndefinedOr, maybeToUor, uorToMaybe)
import Data.Maybe (Maybe, Maybe(..))
import Justifill (justifill)
import Justifill
import Justifill.Justifiable
import Justifill.Fillable
import Prim.Row
import Prim.RowList
import Type.Proxy (Proxy(..))
import Foreign (Foreign, unsafeToForeign)
import Unsafe.Coerce (unsafeCoerce)

type Id :: forall k. k -> k
type Id a = a

foreign import doc :: CM.EditorState -> Effect CM.Doc

foreign import replaceDocWith :: String -> CM.EditorState -> Effect Unit

type StateFieldSpecImpl a =
  { create :: EffectFn1 CM.EditorState a
  , update :: EffectFn2 a CM.Transaction a
  , compare :: UndefinedOr (Fn2 a a Boolean)
  , provide :: EffectFn1 (CM.StateField a) CM.Extension
  }

type StateFieldSpec r a =
  ( create :: CM.EditorState -> Effect a
  , update :: a -> CM.Transaction -> Effect a
  , provide :: (CM.StateField a) -> Effect CM.Extension
  | r
  )

foreign import defineStateFieldImpl :: forall a. (StateFieldSpecImpl a) -> (CM.StateField a)

type Via a =
  StateFieldSpec (compare :: (Compare a)) a

type Minimum a =
  StateFieldSpec () a

type Maybed a =
  StateFieldSpec (compare :: Maybe (Compare a)) a

type Compare a = a -> a -> Boolean

defineStateField
  :: forall from via viaRL a trash
   . Fillable { | via } { | Maybed a }
  => Justifiable { | from } { | via }
  => Union via trash (Maybed a)
  => RowToList via viaRL
  => { | from }
  -> CM.StateField a
defineStateField args =
  defineStateFieldImpl mappedArgs
  where
  justified :: { | via }
  justified = justify args

  maybedArgs :: { | Maybed _ }
  maybedArgs = fill justified

  mappedArgs :: StateFieldSpecImpl _
  mappedArgs = do
    maybedArgs #
      \x ->
        { create: mkEffectFn1 x.create
        , update: mkEffectFn2 x.update
        , compare: x.compare <#> mkFn2 # maybeToUor
        , provide: mkEffectFn1 x.provide
        }

type StateEffectSpecImpl a =
  ( map :: Fn2 a CM.ChangeDesc (UndefinedOr a)
  )

type StateEffectSpec a =
  ( map :: a -> CM.ChangeDesc -> Maybe a
  )

foreign import mapPos :: CM.EditorPosition -> CM.ChangeDesc -> CM.EditorPosition

foreign import defineStateEffectImpl :: forall a r. Fn1 { | r } (CM.StateEffectType a)

defineStateEffect
  :: forall a
   . { | StateEffectSpec a }
  -> CM.StateEffectType a
defineStateEffect args =
  defineStateEffectImpl argsImpl
  where
  argsImpl :: { | StateEffectSpecImpl a }
  argsImpl = args { map = mkFn2 \x y -> args.map x y # maybeToUor }

foreign import of_ :: forall a. a -> CM.StateEffectType a -> CM.StateEffect a

ofForeign :: forall a. a -> CM.StateEffectType a -> CM.StateEffect Foreign
ofForeign x y = of_ x y # unsafeCoerce

foreign import stateEffectIs :: forall a. CM.StateEffect Foreign -> CM.StateEffectType a -> Boolean

toStateEffect :: forall a. CM.StateEffectType a -> CM.StateEffect Foreign -> Maybe (CM.StateEffect a)
toStateEffect t x = if stateEffectIs x t then Just (unsafeCoerce x) else Nothing

stateEffectValue :: forall a. CM.StateEffect a -> a
stateEffectValue x = (unsafeCoerce x).value

foreign import getStateFieldImpl :: forall a. EffectFn2 (CM.StateField a) CM.EditorState (UndefinedOr a)

getStateField :: forall a. CM.StateField a -> CM.EditorState -> Effect (Maybe a)
getStateField sf st = runEffectFn2 getStateFieldImpl sf st <#> uorToMaybe

foreign import appendConfigOf :: Array CM.Extension -> CM.StateEffect Foreign

stateFieldToExtension :: forall a. CM.StateField a -> CM.Extension
stateFieldToExtension = unsafeCoerce

foreign import sliceDoc :: CM.EditorPosition -> CM.EditorPosition -> CM.EditorState -> Effect String