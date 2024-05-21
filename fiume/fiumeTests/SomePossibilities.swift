@testable import fiume

import XCTest

final class SomePossibilities: XCTestCase {
	func test_salary_builds_net_worth() throws {
		let sut = Possibilities()
		sut.add(Stream("Salary", Money(1_000)))

		let data = sut.project(12)

		XCTAssertEqual(data.last!.amount, Money(12_000))
	}

	func test_salary_minus_expenses_creates_net_worth() throws {
		let sut = Possibilities()
		sut.add(Stream("Salary", Money(1_000)))
		sut.add(Stream("Expenses", Money(-900)))

		let data = sut.project(12)

		XCTAssertEqual(data.last!.amount, Money(1_200))
	}

	func test_concretePlans_with_only_groups() {
		let sut = Possibilities()
		sut.add(Stream("Salary", Money(1_000)))
		sut.add(Stream("Expenses", Money(-900)))
		let concretePlans = sut.scenarios()
		XCTAssertEqual(concretePlans.count, 1)
		XCTAssertEqual(concretePlans.first!.net(1), Money(100))
	}
}
