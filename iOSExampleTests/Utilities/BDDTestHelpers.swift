import XCTest

extension XCTestCase {
    @discardableResult
    func given<Result>(_ name: String, block: () throws -> Result) rethrows -> Result {
        return try XCTContext.runActivity(named: "GIVEN \(name)") { _ in try block() }
    }

    @discardableResult
    func when<Result>(_ name: String, block: () throws -> Result) rethrows -> Result {
        return try XCTContext.runActivity(named: "WHEN \(name)") { _ in try block() }
    }

    @discardableResult
    func then<Result>(_ name: String, block: () throws -> Result) rethrows -> Result {
        return try XCTContext.runActivity(named: "THEN \(name)") { _ in try block() }
    }
}
