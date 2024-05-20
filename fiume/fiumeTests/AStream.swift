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

	func test_mergeWhenValuesChange() {
		let stream1 = Stream("Sample", Money(500), first: 1, last: 10)
		let stream2 = Stream("Sample", Money(1000), first: 5, last: 20)
		let merged = stream1.merge(stream2)
		XCTAssertEqual(merged, Stream("Sample", Money(1000), first: 5, last: 20))
	}

	func test_mergeWhenValuesAreOmitted() {
		let stream1 = Stream("Sample", Money(500), first: 1, last: 12)
		let stream2 = Stream("Sample", Money(500), first: 5, last: nil)
		let merged = stream1.merge(stream2)
		XCTAssertEqual(merged, Stream("Sample", Money(500), first: 5, last: 12))
	}

	func test_dontMergeWhenNamesDiffer() {
		let stream1 = Stream("Salary", Money(500), first: 1, last: 12)
		let stream2 = Stream("Different", Money(1500), first: 5, last: 24)
		let merged = stream1.merge(stream2)
		XCTAssertEqual(merged, Stream("Salary", Money(500), first: 1, last: 12))
	}
}
