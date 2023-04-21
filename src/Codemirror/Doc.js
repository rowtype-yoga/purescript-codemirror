export const toString = doc => () => doc.toString()

export const sliceString = from => to => doc => () => doc.sliceString(from, to)