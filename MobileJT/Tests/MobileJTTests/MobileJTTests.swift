import XCTest
@testable import MobileJT

final class MobileJTTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MobileJT().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
