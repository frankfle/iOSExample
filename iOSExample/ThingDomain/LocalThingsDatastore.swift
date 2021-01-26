import Combine
import Foundation

class LocalThingsDatastore: CreateThingUsecase, GetThingsUsecase, CreateThingFailureUsecase, UpdateThingVisibilityUsecase {

    static let `default` = LocalThingsDatastore()

    var currentThings = [Thing]()
    var things = PassthroughSubject<[Thing], ThingError>()

    func create() {
        currentThings.append(Thing(name: newNameStr(), visible: false))
        things.send(currentThings)
    }

    func createFailure() {
        send(failure: .generic)
    }

    func send(failure: ThingError) {
        things.send(completion: Subscribers.Completion.failure(failure))
        things = PassthroughSubject<[Thing], ThingError>()
    }

    func getThings() -> AnyPublisher<[Thing], ThingError> {
        return things.delay(for: 0.3, scheduler: DispatchQueue.main).eraseToAnyPublisher()
    }

    func updateVisibility(thing: Thing, isVisible: Bool) {
        guard let index = currentThings.firstIndex(where: { $0.id == thing.id }) else {
            send(failure: .generic)
            return
        }

        currentThings[index] = newThingWithVisibility(oldThing: currentThings[index], visibility: isVisible)
        things.send(currentThings)
    }
}

func newNameStr() -> String {
    return String(UUID().uuidString.suffix(3).lowercased())
}

func newThingWithVisibility(oldThing: Thing, visibility: Bool) -> Thing {
    return Thing(id: oldThing.id, name: oldThing.name, visible: visibility)
}

