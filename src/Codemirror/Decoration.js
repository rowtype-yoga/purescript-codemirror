import {EditorView, Decoration, DecorationSet, ViewPlugin, WidgetType} from "@codemirror/view"
import {StateField, StateEffect} from "@codemirror/state"
import {keymap} from "@codemirror/view"

export const decorationNone = Decoration.none

export const decorationMarkImpl = arg => Decoration.mark(arg)

export const decorationsFrom = x => () => EditorView.decorations.from(x)

export const decorationRange = from => to => dec => dec.range(from, to)

export const decorationSpec = dec => dec.spec

class GenericPureScriptWidgetType extends WidgetType {
  constructor(initialState, definition) {
    super()
    this.state = initialState
    this.definition = definition
  }

  eq(other) {
    if (!this.definition.eq) { return super.eq(other) }
    return this.definition.eq(this)(other)()
  }

  toDOM(ev) {
    return this.definition.toDOM(this)(ev)()
  }

  ignoreEvent(event) {
    if (!this.definition.ignoreEvent) { return super.ignoreEvent(event) }
    return this.definition.ignoreEvent(event)()
  }
}

export const newWidgetImpl = (initialState) => (args) => () =>
    new GenericPureScriptWidgetType(initialState, args)

export const getWidgetState = w => () => w.state
export const setWidgetState = s => w => () => w.state = s

export const decorationSet = items => Decoration.set(items)

export const sortedDecorationSet = items => Decoration.set(items, true)

export const decorationWidgetImpl = args => Decoration.widget(args)

export const decorationReplaceImpl = args => Decoration.replace(args)

export const iterateRangeSet = rs => () => rs.iter()

export const nextRange = rc => () => {
  rc.next()
}

export const rangeCursorValueImpl = rc => () => rc.value
export const rangeCursorFrom = rc => () => rc.from
export const rangeCursorTo = rc => () => rc.to
