@testable import fiume

import XCTest

typealias Dollar = Int

class Stream {
	var name: String
	var monthlyAmount: Dollar

	init(_ name: String, _ monthlyAmount: Dollar) {
		self.name = name
		self.monthlyAmount = monthlyAmount
	}
}

class Plan {
	var income: Stream = Stream("", 0)
	var netWorth = Dollar(0)

	func add(_ stream: Stream) {
		income = stream
	}

	func project(_ months: Int) {
		(0..<months).forEach { _ in
			netWorth += income.monthlyAmount
		}
	}
}

final class APlan: XCTestCase {
	func test_salaryBuildsNetWorth() throws {
		let plan = Plan()
		plan.add(Stream("Salary", 1_000))

		plan.project(12)

		XCTAssertEqual(plan.netWorth, 12_000)
	}
}
