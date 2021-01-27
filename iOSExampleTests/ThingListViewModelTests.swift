import XCTest
import Combine
@testable import iOSExample

class ThingListViewModelTests: XCTestCase {

    var subject: ThingListView.ViewModel!
    var addUsecaseMock: CreateThingUsecaseMock!
    var addFailureMock: CreateThingFailureUsecaseMock!
    var updateMock: UpdateThingVisibilityUsecaseMock!

    override func setUpWithError() throws {
        subject = ThingListView.ViewModel()
        addUsecaseMock = CreateThingUsecaseMock()
        addFailureMock = CreateThingFailureUsecaseMock()
        updateMock = UpdateThingVisibilityUsecaseMock()

        subject.thingCreater = addUsecaseMock
        subject.thingErrorer = addFailureMock
        subject.thingUpdater = updateMock
    }

    func test_add_thing() {
        given("subject") {
            when("add thing is called") {
                subject.addThing()
                then("add thing usecase is called") {
                    XCTAssertTrue(addUsecaseMock.createCalled)
                }
            }
        }
    }

    func test_add_thing_error() {
        given("subject") {
            when("add thing error is called") {
                subject.addThingError()
                then("add thing error usecase is called") {
                    XCTAssertTrue(addFailureMock.createFailureCalled)
                }
            }
        }
    }

    func test_clear_alert() {
        given("an alert is present") {
            subject.alertPresent = true
            when("alert clear is called") {
                subject.clearAlert()
                then("alert it cleared") {
                    XCTAssertFalse(subject.alertPresent)
                }
            }
        }
    }

    func test_update_thing() {
        given("a thing") {
            let thing = Thing(name: "aThing", visible: false)
            when("update is called") {
                subject.updtateVisibility(thing: thing, visibility: true)
                then("usecase is called") {
                    XCTAssertTrue(updateMock.updateVisibilityCalled)
                }
            }
        }
    }

    func test_get_things_with_things() {
        given("there are things to return") {
            let mock = GetThingsUsecaseMock()
            subject.thingGetter = mock
            when("get things is called") {
                subject.getThings()
                then("the things are published") {
                    XCTAssertEqual(subject.things[0].id, mock.thingToReturn.id)
                }
            }
        }
    }

    func test_get_things_with_error() {
        given("an error is returned from usecase") {
            let mock = GetThingsUsecaseErrorMock()
            subject.thingGetter = mock
            when("get things is called") {
                subject.getThings()
                then("an alert is presented") {
                    XCTAssertTrue(subject.alertPresent)
                }
            }
        }
    }
}

class CreateThingUsecaseMock: CreateThingUsecase {
    var createCalled = false
    func create() {
        createCalled = true
    }
}

class CreateThingFailureUsecaseMock: CreateThingFailureUsecase {
    var createFailureCalled = false
    func createFailure() {
        createFailureCalled = true
    }
}

class UpdateThingVisibilityUsecaseMock: UpdateThingVisibilityUsecase {
    var updateVisibilityCalled = false
    func updateVisibility(thing: Thing, isVisible: Bool) {
        updateVisibilityCalled = true
    }
}

class GetThingsUsecaseMock: GetThingsUsecase {
    var thingToReturn = Thing(name: "AA", visible: false)
    func getThings() -> AnyPublisher<[Thing], ThingError> {
        return Just([thingToReturn]).setFailureType(to: ThingError.self).eraseToAnyPublisher()
    }
}

class GetThingsUsecaseErrorMock: GetThingsUsecase {
    var errorToReturn = ThingError.generic
    func getThings() -> AnyPublisher<[Thing], ThingError> {
        let ps = PassthroughSubject<[Thing], ThingError>()
        ps.send(completion: Subscribers.Completion.failure(errorToReturn))
        return ps.eraseToAnyPublisher()
    }
}
