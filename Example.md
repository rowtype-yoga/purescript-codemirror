```purs
module Editor.Plugin.Image where

import Prelude
import Codemirror.Types (Decoration, DecorationSet, EditorState, Extension, Range, RangeSet, SelectionRange, StateEffect, StateEffectType, StateField, Transaction, Widget) as CM
import Codemirror.Decoration (decorationMark, decorationRange, decorationRangeAt, decorationReplace, decorationWidget, decorationsFrom, getWidgetState, newWidget, psWidgetToWidget, sortedDecorationSet)
import Effect (Effect)
import Codemirror.Transaction (effectsTransaction, mapRangeSet, toChangeDesc, updateRangeSet)
import Unsafe.Coerce (unsafeCoerce)
import Codemirror.State (defineStateEffect, defineStateField, sliceDoc, stateEffectValue, toStateEffect)
import Codemirror.Transaction (changes, effects) as CTR
import Codemirror.Decoration (decorationNone) as CMD
import Data.Maybe (Maybe(Just), Maybe(..), fromMaybe, maybe)
import Data.Array (foldl, mapMaybe, singleton, snoc) as Array
import Web.HTML (window)
import Web.HTML.HTMLDocument (toDocument) as HTMLDoc
import Web.DOM.Document (createElement)
import Web.DOM.Element (setAttribute, setClassName, toNode)
import Web.DOM.Node (appendChild)
import Web.HTML.HTMLElement (fromElement) as HTMLElement
import Control.Monad.Error.Class (throwError)
import Effect.Aff (error)
import Codemirror.View (dispatch, state, visibleRanges)
import Effect.Ref (modify_, new, read) as Ref
import Codemirror.Language (iterate, syntaxTree)
import Data.Foldable (for_)
import Effect.Uncurried (mkEffectFn1, runEffectFn1)
import Codemirror.Types (EditorPosition, SyntaxNodeName(SyntaxNodeName), WidgetType)
import Debug (spy)
import Effect.Unsafe (unsafePerformEffect)
import Data.Nullable (toMaybe) as Nullable
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.String.Regex (match) as Regex
import Data.String.Regex.Flags (noFlags)
import Data.Array.NonEmpty (head) as NEA
import Codemirror.Lang.Markdown (mdNode)
import Web.HTML.Window (document)
import Codemirror.SyntaxNode (getChild) as SN
import Data.Traversable (for)
import Web.Event.EventTarget (addEventListener) as DOM
import Web.DOM.Element (classList, setAttribute, setClassName) as DOM
import Web.DOM.Document (createElement) as DOM
import Data.Set (map)

addImageStateEffect :: CM.StateEffectType (CM.SelectionRange)
addImageStateEffect = defineStateEffect
  { map: \sr mapping -> do
      let { from, to } = unsafeCoerce sr
      Just (unsafeCoerce { from, to })
  }

images view = do
  result <- Ref.new ([] :: _ (CM.Range (CM.Decoration ())))
  ranges <- view # visibleRanges
  tree <- view # state >>= syntaxTree
  for_ ranges \range -> do
    let { from, to } = range
    tree # iterate
      { from
      , to
      , enter: mkEffectFn1 \node -> do
          when (node.name == SyntaxNodeName "Image") do
            widget <- imageWidget "alt" "https://i.imgur.com/1QJQZ9r.png"
            let wid = decorationReplace { widget, inclusive: true, block: true }
            let decoRange = wid # decorationRange node.from node.to
            result # Ref.modify_ (Array.snoc <@> decoRange)
          pure true

      }
  Ref.read result <#> sortedDecorationSet

imageWidget :: _ -> _ -> Effect CM.Widget
imageWidget alt src = do
  psWidget <- newWidget
    true
    { toDOM: \self _ -> do
        doc <- window >>= document <#> HTMLDoc.toDocument
        wrap <- createElement "span" doc
        wrap # setClassName "cm-image"
        img <- createElement "img" doc
        setAttribute "src" src img
        setAttribute "alt" alt img
        appendChild (toNode img) (toNode wrap)
        result <- HTMLElement.fromElement wrap # maybe
          (throwError (error "Could not cast to HTMLElement"))
          pure
        pure result

    , eq: \self other -> do
        selfState <- getWidgetState self
        otherState <- getWidgetState other
        pure $ selfState == otherState
    , ignoreEvent: const $ pure false
    }
  pure $ psWidgetToWidget psWidget

--function extractImages(state: EditorState): ImageInfo[] {
--	const imageUrls: ImageInfo[] = [];
--	syntaxTree(state).iterate({
--		enter: ({ name, node, from, to }) => {
--			if (name !== 'Image') return;
--			const alt = state.sliceDoc(from, to).match(imageTextRE).pop();
--			const urlNode = node.getChild('URL');
--			if (urlNode) {
--				const url = state.sliceDoc(urlNode.from, urlNode.to);
--				imageUrls.push({ src: url, from, to, alt });
--			}
--		}
--	});
--	return imageUrls;
--}

type ImageInfo =
  { src :: String
  , from :: EditorPosition
  , to :: EditorPosition
  , alt :: Maybe String
  }

imageTextRE = unsafeRegex """(?:!\[)(.*?)(?:\])""" noFlags

extractImages :: CM.EditorState -> Effect (Array ImageInfo)
extractImages state = do
  result <- Ref.new ([] :: _ ImageInfo)
  tree <- state # syntaxTree
  tree # iterate
    { enter: mkEffectFn1 \node -> do
        when (node.name == mdNode.image) do
          alt <- state # sliceDoc node.from node.to <#> \sliced ->
            Regex.match imageTextRE sliced >>= NEA.head
          urlNode <- node.node # SN.getChild mdNode.url
          case urlNode of
            Just urlNode -> do
              url <- state # sliceDoc urlNode.from urlNode.to
              result # Ref.modify_ (Array.snoc <@> { src: url, from: node.from, to: node.to, alt })
            Nothing -> pure unit
        pure true
    }
  Ref.read result

data ImageWidgetState = ImageInitial | ImageLoaded

--imagePreview = defineStateField { create, update }
--  where
--  create = do
--    images <- extractImages
--    decorations <- for images \img -> do
--      widget <- imagePreviewWidget img ImageInitial
--      pure $ decorationWidget { widget, block: true, side: 1, info: img, src: img.src } # decorationRange img.to img.to
--    pure $ sortedDecorationSet decorations
--
--  update value tx = do
--    mempty

--class ImagePreviewWidget extends WidgetType {
--	constructor(
--		public readonly info: ImageInfo,
--		public readonly state: WidgetState
--	) {
--		super();
--	}
--
--	toDOM(view: EditorView): HTMLElement {
--		const img = new Image();
--		img.classList.add(classes.widget);
--		img.src = this.info.src;
--		img.alt = this.info.alt;
--
--		img.addEventListener('load', () => {
--			const tx: TransactionSpec = {};
--			if (this.state === WidgetState.INITIAL) {
--				tx.effects = [
--					// Indicate image has loaded by setting the loaded value
--					imageLoadedEffect.of({ ...this.info, loaded: true })
--				];
--			}
--			// After this is dispatched, this widget will be updated,
--			// and since the image is already loaded, this will not change
--			// its height dynamically, hence prevent all sorts of weird
--			// mess related to other parts of the editor.
--			view.dispatch(tx);
--		});
--
--		if (this.state === WidgetState.LOADED) return img;
--		// Render placeholder
--		else return new Image();
--	}
--
--	eq(widget: ImagePreviewWidget): boolean {
--		return (
--			JSON.stringify(widget.info) === JSON.stringify(this.info) &&
--			widget.state === this.state
--		);
--	}
--}

imageWidgetClass = "sentence-image-widget"

addImagePreview = defineStateEffect
  { map: \sr mapping -> do
      let { from, to } = unsafeCoerce sr
      Just (unsafeCoerce { from, to })
  }

imagePreviewWidget :: ImageInfo -> ImageWidgetState -> Effect CM.Widget
imagePreviewWidget info state = psWidgetToWidget <$> newWidget true
  { toDOM: \self view -> do
      doc <- window >>= document <#> HTMLDoc.toDocument
      img <- DOM.createElement "img" doc
      DOM.setClassName imageWidgetClass img
      DOM.setAttribute "src" info.src img
      for_ info.alt \alt -> img # DOM.setAttribute "alt" alt
      result <- HTMLElement.fromElement img # maybe
        (throwError (error "Could not cast to HTMLElement"))
        pure
      pure result
  --        DOM.addEventListener "load" \_ -> do
  --
  --          when (state == ImageInitial) do
  --            effects <- Array.singleton <$> imageLoadedEffect { src: info.src, loaded: true }
  --            view # dispatch (effectsTransaction { effects })
  --        if state == ImageLoaded then pure img else DOM.createElement "img" then
  --          mempty else mempty

  , eq: \self other -> do
      selfState <- getWidgetState self
      otherState <- getWidgetState other
      pure $ selfState == otherState
  , ignoreEvent: const $ pure false
  }

-- FIXME continue here, but it's hard
imagePreviewField :: CM.StateField (CM.DecorationSet ())
imagePreviewField = defineStateField
  { create
  , update
  , provide
  }
  where
  create :: CM.EditorState -> Effect (CM.DecorationSet ())
  create state = do
    images <- extractImages state
    pure CMD.decorationNone

  update :: CM.DecorationSet () -> CM.Transaction -> Effect (CM.DecorationSet ())
  update old tr = pure do
    let
      images :: CM.DecorationSet ()
      images = old # mapRangeSet (toChangeDesc (CTR.changes tr))

      imageEffects :: Array (CM.StateEffect (CM.SelectionRange))
      imageEffects = tr # CTR.effects # Array.mapMaybe (toStateEffect addImagePreview)
    Array.foldl foldFn images imageEffects
    where
    foldFn :: CM.DecorationSet () -> CM.StateEffect CM.SelectionRange -> CM.DecorationSet ()
    foldFn us e = do
      let { from, to } = e # stateEffectValue # unsafeCoerce
      let
        widget =
          imageWidget "alt" "https://i.imgur.com/1QJQZ9r.png" # unsafePerformEffect
      let deco = decorationWidget { widget } :: CM.Decoration ()
      us # updateRangeSet { add: [ deco ] }

  provide :: CM.StateField (CM.DecorationSet ()) -> Effect CM.Extension
  provide = decorationsFrom
```
