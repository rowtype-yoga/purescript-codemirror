module Codemirror.Lang.Markdown where

import Codemirror.Types as CM
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row (class Union)
import Codemirror.Types (SyntaxNodeName(SyntaxNodeName))

type MarkdownArgs =
  ( addKeymap ∷ Boolean
  -- defaultCodeLanguage?: Language | LanguageSupport;
  -- codeLanguages?: readonly LanguageDescription[] | ((info: string) => Language | LanguageDescription | null);
  -- extensions?: MarkdownExtension;
  -- base?: Language;
  )

foreign import markdownImpl ∷ ∀ args. EffectFn1 args CM.Extension

markdown
  ∷ ∀ args args_. Union args args_ MarkdownArgs ⇒ { | args } → Effect CM.Extension
markdown = runEffectFn1 markdownImpl

mdNode =
  { image: SyntaxNodeName "Image"
  , url: SyntaxNodeName "URL"
  }