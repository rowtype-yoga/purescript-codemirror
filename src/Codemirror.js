import { EditorState } from "@codemirror/state";
import { EditorView } from "@codemirror/view";
import { highlightSpecialChars, drawSelection, highlightActiveLine, dropCursor,
        rectangularSelection, crosshairCursor,
        lineNumbers, highlightActiveLineGutter} from "@codemirror/view"
import * as view from "@codemirror/view"
import {defaultHighlightStyle, syntaxHighlighting, indentOnInput, bracketMatching,
        foldGutter, foldKeymap} from "@codemirror/language"
import {history, historyKeymap} from "@codemirror/commands"
import {defaultKeymap as defKmp } from "@codemirror/commands"
import {searchKeymap, highlightSelectionMatches} from "@codemirror/search"
import {autocompletion, completionKeymap, closeBrackets, closeBracketsKeymap} from "@codemirror/autocomplete"
import {lintKeymap} from "@codemirror/lint"
import { Decoration, DecorationSet, ViewPlugin} from "@codemirror/view"

import {StateField, StateEffect} from "@codemirror/state"

export const defaultKeymap = defKmp
export const keymap = view.keymap
export const createEditorStateImpl = args => { return EditorState.create(args) }
export const keymapOfImpl = km => { return keymap.of(km) }
export const newEditorViewImpl = args => { return new EditorView(args) }
export const destroy = view => () => view.destroy()
export const lineWrapping = EditorView.lineWrapping

export const basicSetup = (() => [
    // lineNumbers(),
    //highlightActiveLineGutter(),
    //highlightSpecialChars(),
    //history(),
    // foldGutter(),
    drawSelection(),
    //dropCursor(),
    //EditorState.allowMultipleSelections.of(true),
    //indentOnInput(),
    //syntaxHighlighting(defaultHighlightStyle, {fallback: true}),
    //bracketMatching(),
    //closeBrackets(),
    //autocompletion(),
    //rectangularSelection(),
    //crosshairCursor(),
    //highlightActiveLine(),
    //highlightSelectionMatches(),
    keymap.of([
        //...closeBracketsKeymap,
        ...defaultKeymap,
        //...searchKeymap,
        //...historyKeymap,
        //...foldKeymap,
        //...completionKeymap,
        //...lintKeymap,
    ]),
    //underlineKeymap,
])()
