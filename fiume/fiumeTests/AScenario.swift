@testable import fiume
import XCTest

final class AScenario: XCTestCase {
	func test_makes_independent_copies() {
		let sut = Scenario()
		let stream = Stream("Income1", 1_000, first: 1, last: 12)
		sut.add(stream)

		let result = sut.copies(1).first!
		let stream2 = Stream("Income2", 2_000, first: 1, last: 12)
		result.add(stream2)

		XCTAssertEqual(sut.net(1), Money(1_000))
		XCTAssertEqual(result.net(1), Money(3_000))
	}

	func test_built_for_one_stream() {
		let sut = Scenario()
		let stream = Stream("Income1", 1_000, first: 1, last: 12)

		sut.add(stream)

		XCTAssertEqual(sut.net(12), Money(1_000))
		XCTAssertEqual(sut.net(13), Money(0))
	}

	func test_built_for_multiple_streams() {
		let sut = Scenario()
		let stream1 = Stream("Income1", 1_000, first: 1, last: 12)
		let stream2 = Stream("Income2", 500, first: 10, last: nil)

		sut.add(stream1)
		sut.add(stream2)

		XCTAssertEqual(sut.net(1), Money(1_000))
		XCTAssertEqual(sut.net(10), Money(1_500))
		XCTAssertEqual(sut.net(12), Money(1_500))
		XCTAssertEqual(sut.net(13), Money(500))
	}

	func test_built_for_merged_streams() {
		let sut = Scenario()
		let stream1 = Stream("Income1", 1_000, first: 1, last: 12)
		let stream2 = Stream("Income1", 500, first: 10, last: nil)

		sut.add(stream1)
		sut.add(stream2)

		XCTAssertEqual(sut.net(1), Money(0))
		XCTAssertEqual(sut.net(10), Money(500))
		XCTAssertEqual(sut.net(12), Money(500))
		XCTAssertEqual(sut.net(13), Money(0))
	}
}