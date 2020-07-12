import XCTest
@testable import SimpleToast

final class SimpleToastTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SimpleToast().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
