@testable import fiume
import XCTest

final class AStream: XCTestCase {
	func test_amountInsideDateRange() throws {
		let stream = Stream("Sample", Money(100), first: 1, last: 10)
		XCTAssertEqual(stream.amount(month: 1), Money(100))
		XCTAssertEqual(stream.amount(month: 10), Money(100))
	}

	func test_amountOutsideDateRange() throws {
		let stream = Stream("Sample", Money(100), first: 1, last: 10)
		XCTAssertEqual(stream.amount(month: 0), Money(0))
		XCTAssertEqual(stream.amount(month: 12), Money(0))
	}
}
