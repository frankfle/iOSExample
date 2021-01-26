import Foundation

struct Thing: Identifiable {
    var id = UUID()

    let name: String
    let visible: Bool
}

enum ThingError: Error {
    case generic
    case specific
    case epic
    case minor
}
