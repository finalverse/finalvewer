import XCTest

final class FinalviewerAppUITests: XCTestCase {
    func testLoginScreenAppears() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.textFields["Username"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
    }
}
