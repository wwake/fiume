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

	func test_concretePlans_with_only_groups() {
		let plan = MultiScenarioPlan()
		plan.add(Stream("Salary", Money(1_000)))
		plan.add(Stream("Expenses", Money(-900)))
		let concretePlans = plan.concretePlans()
		XCTAssertEqual(concretePlans.count, 1)
		XCTAssertEqual(concretePlans.first!.net(1), Money(100))
	}
}
