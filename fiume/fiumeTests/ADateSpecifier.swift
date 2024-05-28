@testable import fiume
import XCTest

final class ADateSpecifier: XCTestCase {
  func test_equatable() throws {
    XCTAssertEqual(DateSpecifier.unspecified, DateSpecifier.unspecified)
    XCTAssertNotEqual(DateSpecifier.month(3), DateSpecifier.unspecified)
    XCTAssertNotEqual(DateSpecifier.unspecified, DateSpecifier.month(3))
    XCTAssertEqual(DateSpecifier.month(3), DateSpecifier.month(3))
    XCTAssertNotEqual(DateSpecifier.month(3), DateSpecifier.month(4))
  }
}
