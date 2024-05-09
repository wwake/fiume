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
	var streams = [Stream]()
	var netWorth = Dollar(0)

	func add(_ stream: Stream) {
		streams.append(stream)
	}

	func project(_ months: Int) {
		(0..<months).forEach { _ in
			streams.forEach { stream in
				netWorth += stream.monthlyAmount
			}
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

	func test_salaryMinusExpensesCreatesNetWorth() throws {
		let plan = Plan()
		plan.add(Stream("Salary", 1_000))
		plan.add(Stream("Expenses", -900))

		plan.project(12)

		XCTAssertEqual(plan.netWorth, 1_200)
	}
}
