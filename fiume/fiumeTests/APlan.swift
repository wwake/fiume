@testable import fiume

import XCTest

final class APlan: XCTestCase {
	func test_salaryBuildsNetWorth() throws {
		let plan = Plan()
		plan.add(Stream("Salary", 1_000))

		let data = plan.project(12)

		XCTAssertEqual(data.last!.amount, 12_000)
	}

	func test_salaryMinusExpensesCreatesNetWorth() throws {
		let plan = Plan()
		plan.add(Stream("Salary", 1_000))
		plan.add(Stream("Expenses", -900))

		let data = plan.project(12)

		XCTAssertEqual(data.last!.amount, 1_200)
	}
}
