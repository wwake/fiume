@testable import fiume

import XCTest

final class AMultiScenarioPlan: XCTestCase {
	func test_salaryBuildsNetWorth() throws {
		let plan = MultiScenarioPlan()
		plan.add(Stream("Salary", Money(1_000)))

		let data = plan.project(12)

		XCTAssertEqual(data.last!.amount, Money(12_000))
	}

	func test_salaryMinusExpensesCreatesNetWorth() throws {
		let plan = MultiScenarioPlan()
		plan.add(Stream("Salary", Money(1_000)))
		plan.add(Stream("Expenses", Money(-900)))

		let data = plan.project(12)

		XCTAssertEqual(data.last!.amount, Money(1_200))
	}

	func test_plan3() {
		
	}
}
