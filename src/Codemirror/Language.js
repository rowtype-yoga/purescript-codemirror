import { syntaxHighlighting, HighlightStyle
  , syntaxTree as syntaxTree_
    , syntaxTreeAvailable as syntaxTreeAvailable_
} from "@codemirror/language";
import { tags } from "@lezer/highlight";

const markdownHighlighting = HighlightStyle.define([
  { tag: tags.heading1, 
    fontSize: "1.6em", 
    fontWeight: "bold" },
  {
    tag: tags.heading2,
    fontSize: "1.4em",
    fontWeight: "bold",
  },
  {
    tag: tags.heading3,
    fontSize: "1.2em",
    fontWeight: "bold",
  },
]);

export const markdownSyntaxHighlighting = () => syntaxHighlighting(markdownHighlighting);

export const syntaxTree = (state) => () => syntaxTree_(state);

export const syntaxTreeAvailable = (state) => () => syntaxTreeAvailable_(state);
export const syntaxTreeAvailableUpTo = int => (state) => () => syntaxTreeAvailable_(state, int);

export const iterateImpl = fn => (tree) => () => tree.iterate(fn)
