@testable import fiume
import XCTest

final class AStream: XCTestCase {
	func test_amountInValidDateRange() throws {
		let stream = Stream("Sample", Dollar(100), first: 1, last: 10)
		XCTAssertEqual(stream.amount(month: 1), Dollar(100))
		XCTAssertEqual(stream.amount(month: 10), Dollar(100))
	}

	func test_amountOutsideDateRange() throws {
		let stream = Stream("Sample", Dollar(100), first: 1, last: 10)
		XCTAssertEqual(stream.amount(month: 0), Dollar(0))
		XCTAssertEqual(stream.amount(month: 12), Dollar(0))
	}
}
