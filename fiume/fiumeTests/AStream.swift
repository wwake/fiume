@testable import fiume
import XCTest

final class AStream: XCTestCase {
	func test_determines_amount_inside_date_range() throws {
		let sut = Stream("Sample", Money(100), first: 1, last: 10)
		XCTAssertEqual(sut.amount(month: 1), Money(100))
		XCTAssertEqual(sut.amount(month: 10), Money(100))
	}

	func test_determines_amount_outside_date_range() throws {
		let sut = Stream("Sample", Money(100), first: 1, last: 10)
		XCTAssertEqual(sut.amount(month: 0), Money(0))
		XCTAssertEqual(sut.amount(month: 12), Money(0))
	}

	func test_merge_when_values_change() {
		let stream1 = Stream("Sample", Money(500), first: 1, last: 10)
		let stream2 = Stream("Sample", Money(1_000), first: 5, last: 20)
		let sut = stream1.merge(stream2)
		XCTAssertEqual(sut, Stream("Sample", Money(1_000), first: 5, last: 20))
	}

	func test_merge_when_values_are_omitted() {
		let stream1 = Stream("Sample", Money(500), first: 1, last: 12)
		let stream2 = Stream("Sample", Money(500), first: 5, last: nil)

		let sut = stream1.merge(stream2)

		XCTAssertEqual(sut, Stream("Sample", Money(500), first: 5, last: 12))
	}

	func test_dontMergeWhenNamesDiffer() {
		let stream1 = Stream("Salary", Money(500), first: 1, last: 12)
		let stream2 = Stream("Different", Money(1_500), first: 5, last: 24)
		let merged = stream1.merge(stream2)
		XCTAssertEqual(merged, Stream("Salary", Money(500), first: 1, last: 12))
	}
}
