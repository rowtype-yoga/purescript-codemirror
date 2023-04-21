export const changes = tr => tr.changes
export const effects = tr => tr.effects

export const mapRangeSet = changes => rs => rs.map(changes)

export const updateRangeSet = x => rs => rs.update(x)