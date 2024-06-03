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

  func test_update_when_values_change() {
    let value1 = DateSpecifier.month(10)
    let value2 = DateSpecifier.month(12)
    let sut = value1.update(using: value2)
    XCTAssertEqual(sut, DateSpecifier.month(12))
  }

  func test_update_retains_original_when_new_value_is_unspecified() {
    let value1 = DateSpecifier.month(10)
    let value2 = DateSpecifier.unspecified
    let sut = value1.update(using: value2)
    XCTAssertEqual(sut, DateSpecifier.month(10))
  }
}
