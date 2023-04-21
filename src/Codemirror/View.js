import {EditorView, ViewPlugin, ViewUpdate} from "@codemirror/view";

export const state = view => () => view.state

export const stateField = field => state => () => state.field(field)

export const selection = state => () => state.selection

export const ranges = selection => () => selection.ranges

export const selectionRangeEmpty = range => range.empty

export const selectionFrom = range => range.from

export const selectionTo = range => range.to

export const dispatch = args => view => () => view.dispatch(args)

export const visibleRanges = view => () => view.visibleRanges

export const newViewPlugin = create => spec => () =>
    ViewPlugin.define(x => create(x)(), spec)

export const updateListenerOf = fn => EditorView.updateListener.of(
    x => fn( x )()
)