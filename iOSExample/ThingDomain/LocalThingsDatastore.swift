import Combine
import Foundation

class LocalThingsDatastore: CreateThingUsecase, GetThingsUsecase, CreateThingFailureUsecase {

    static let `default` = LocalThingsDatastore()

    var currentThings = [Thing]()
    var things = PassthroughSubject<[Thing], ThingError>()

    func create() {
        currentThings.append(Thing(name: newNameStr(), visible: [true, false].randomElement()!))
        things.send(currentThings)
    }

    func createFailure() {
        things.send(completion: Subscribers.Completion.failure(ThingError.generic))
        things = PassthroughSubject<[Thing], ThingError>()
    }

    func getThings() -> AnyPublisher<[Thing], ThingError> {
        return things.delay(for: 0.3, scheduler: DispatchQueue.main).eraseToAnyPublisher()
    }
}

func newNameStr() -> String {
    return String(UUID().uuidString.suffix(3).lowercased())
}
