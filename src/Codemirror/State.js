import {StateField, StateEffect} from "@codemirror/state"

export const defineStateFieldImpl = config => {
    return StateField.define(config);
}

export const defineStateEffectImpl = config => {
    return StateEffect.define(config);
}

export const doc = state => () => state.doc

export const replaceDocWith = str => state => () => state.update({
    changes: { from: 0, to: state.doc.length, insert: str }
})

export const of_ = v => eff => eff.of(v)

export const stateEffectIs = se1 => se2 => se1.is(se2)

export const getStateFieldImpl = (f, state) => {
    state.field(f, false)
}

export const mapPos = p => cd => {
    cd.mapPos(p)
}

export const appendConfigOf = extensions =>
    StateEffect.appendConfig.of(extensions)

export const updateRangeSet = stuff => rs => rs.update(stuff)

export const sliceDoc = from => to => state => () => state.sliceDoc(from, to)