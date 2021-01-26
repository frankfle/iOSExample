import Foundation

struct Thing: Identifiable {
    var id = UUID()

    let name: String
    let visible: Bool

    init(id: UUID = UUID(), name: String, visible: Bool) {
        self.id = id
        self.name = name
        self.visible = visible
    }
}

enum ThingError: Error {
    case generic
    case specific
    case epic
    case minor
}
