@testable import fiume
import XCTest

final class AConcretePlan: XCTestCase {
	func test_concrete_plans_for_one_stream() {
		let plan = ConcretePlan()
		let stream = Stream("Income1", 1000, first: 1, last: 12)

		plan.add(stream)

		XCTAssertEqual(plan.net(12), Money(1000))
		XCTAssertEqual(plan.net(13), Money(0))
	}

	func test_concrete_plans_for_multiple_streams() {
		let plan = ConcretePlan()
		let stream1 = Stream("Income1", 1000, first: 1, last: 12)
		let stream2 = Stream("Income2", 500, first: 10, last: nil)

		plan.add(stream1)
		plan.add(stream2)

		XCTAssertEqual(plan.net(1), Money(1000))
		XCTAssertEqual(plan.net(10), Money(1500))
		XCTAssertEqual(plan.net(12), Money(1500))
		XCTAssertEqual(plan.net(13), Money(500))
	}
}
