import XCTest
import Combine
@testable import iOSExample

class LocalThingsDatastoreTests: XCTestCase {

    var subject: LocalThingsDatastore!
    var pipe: AnyCancellable?

    override func setUpWithError() throws {
        subject = LocalThingsDatastore()
    }

    func test_get_things_with_default_value() {
        given("there is a thing") {
            subject.currentThings = [Thing(name: "A", visible: false)]
            when("get things is called") {
                var receivedThings = [Thing]()
                pipe = subject.getThings().sink { (error) in
                    XCTFail("Received error when expecting values")
                } receiveValue: { (newThings) in
                    receivedThings = newThings
                }

                then("thing is received through publisher") {
                    XCTAssertEqual(receivedThings[0].id, subject.currentThings[0].id)
                }
            }
        }
    }

    func test_create_thing() {
        given("things values are being observed and there are no things") {

            var receivedThings = [Thing]()
            pipe = subject.getThings().sink { (error) in
                XCTFail("Received error when expecting values")
            } receiveValue: { (newThings) in
                receivedThings = newThings
            }

            XCTAssertEqual(receivedThings.count, 0)

            when("a thing is created") {

                subject.create()

                then("a new thing is received through publisher") {
                    XCTAssertEqual(receivedThings.count, 1)
                }
            }
        }
    }

    func test_update_thing() {
        given("we have an invisible thing") {
            subject.currentThings = [Thing(name: "A", visible: false)]

            var receivedThings = [Thing]()
            pipe = subject.getThings().sink { (error) in
                XCTFail("Received error when expecting values")
            } receiveValue: { (newThings) in
                receivedThings = newThings
            }

            when("a thing is updated") {
                subject.updateVisibility(thing: receivedThings[0], isVisible: true)

                then("thing should be modified and sent back to visible") {
                    XCTAssertTrue(receivedThings[0].visible)
                }
            }
        }
    }

    func test_update_invalid_thing() {
        given("we have an invisible thing") {
            subject.currentThings = [Thing(name: "A", visible: false)]
            let invalidThing = Thing(name: "B", visible: false)

            var receivedError: ThingError?

            pipe = subject.getThings().sink { (error) in
                switch error {
                case .finished:
                    break
                case .failure(let e):
                    receivedError = e
                }
            } receiveValue: { _ in }

            when("the invalid thing is updated") {
                subject.updateVisibility(thing: invalidThing, isVisible: true)

                then("subscription receives the appropriate error") {
                    XCTAssertEqual(receivedError, ThingError.generic)
                }
            }
        }
    }

    func test_create_error() {
        given("") {
            var receivedError: ThingError?
            pipe = subject.getThings().sink { (error) in
                switch error {
                case .finished:
                    break
                case .failure(let e):
                    receivedError = e
                }
            } receiveValue: { _ in }

            when("create error is called") {
                subject.createFailure()
                then("subscription receives the appropriate error") {
                    XCTAssertEqual(receivedError, ThingError.generic)
                }
            }
        }
    }
}
