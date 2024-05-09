@testable import fiume

import XCTest

typealias Dollar = Int

class Stream {
	init(_ name: String, _ monthlyAmount: Dollar) {

	}
}

class Plan {
	func add(_ stream: Stream) {

	}

	func project(_ months: Int) {


	}

	var netWorth: Dollar { 12_000 }
}

final class APlan: XCTestCase {
	func test_salaryBuildsNetWorth() throws {
		var plan = Plan()
		plan.add(Stream("Salary", 1_000))

		plan.project(12)

		XCTAssertEqual(plan.netWorth, 12_000)
	}
}
