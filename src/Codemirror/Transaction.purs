module Codemirror.Transaction where

import Codemirror.Types as CM
import Foreign (Foreign)
import Unsafe.Coerce (unsafeCoerce)

foreign import changes :: forall a. CM.Transaction -> CM.ChangeSet

foreign import effects :: CM.Transaction -> Array (CM.StateEffect Foreign)

foreign import mapRangeSet :: forall a. CM.ChangeDesc -> CM.RangeSet a -> CM.RangeSet a

foreign import updateRangeSet :: forall a updates. { | updates } -> CM.RangeSet a -> CM.RangeSet a

toChangeDesc :: CM.ChangeSet -> CM.ChangeDesc
toChangeDesc = unsafeCoerce

effectsTransaction :: { effects :: Array (CM.StateEffect Foreign) } -> CM.Transaction
effectsTransaction = unsafeCoerce