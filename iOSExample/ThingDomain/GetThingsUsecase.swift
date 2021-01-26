import Combine

protocol GetThingsUsecase {
    func getThings() -> AnyPublisher<[Thing], ThingError>
}
