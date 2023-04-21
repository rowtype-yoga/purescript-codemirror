module Codemirror.SyntaxNode where

import Prelude
import Codemirror.Types (EditorPosition, SyntaxNode, SyntaxNodeName, SyntaxNodeRef) as CM
import Data.Nullable (Nullable)
import Effect (Effect)
import Data.Nullable (toMaybe) as Nullable
import Data.Maybe (Maybe)

foreign import getChildImpl :: CM.SyntaxNodeName -> CM.SyntaxNode -> Effect (Nullable CM.SyntaxNodeRef)

getChild :: CM.SyntaxNodeName -> CM.SyntaxNode -> Effect (Maybe CM.SyntaxNodeRef)
getChild n = getChildImpl n >>> map Nullable.toMaybe
