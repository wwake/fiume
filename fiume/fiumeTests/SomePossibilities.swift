@testable import fiume

import XCTest

final class SomePossibilities: XCTestCase {
	func test_salary_builds_net_worth() throws {
		let sut = Possibilities()
		sut.add(Stream("Salary", Money(1_000)))

		let data = sut.project(12)

    XCTAssertEqual(data[0].netWorthByMonth.last!.amount, Money(12_000))
	}

	func test_salary_minus_expenses_creates_net_worth() throws {
		let sut = Possibilities()
		sut.add(Stream("Salary", Money(1_000)))
		sut.add(Stream("Expenses", Money(-900)))

		let data = sut.project(12)

    XCTAssertEqual(data[0].netWorthByMonth.last!.amount, Money(1_200))
	}

	func test_scenarios_with_only_groups() {
		let sut = Possibilities()
		sut.add(Stream("Salary", Money(1_000)))
		sut.add(Stream("Expenses", Money(-900)))

    let result = Array(sut.scenarios())

		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result.first!.net(1), Money(100))
	}

  func test_adds_scenarios() {
    let sut = Possibilities()
    let orTree = OrTree("jobs")
    orTree.append(PlanLeaf(Stream("Salary1", Money(1_000))))
    orTree.append(PlanLeaf(Stream("Salary2", Money(2_000))))
    sut.add(orTree)

    print(sut.plan)

    let result = Array(sut.scenarios())

    XCTAssertEqual(result.count, 2)
  }

  func test_computes_net_worth_for_multiple_scenarios() {
    let sut = Possibilities()
    let orTree = OrTree("jobs")
    orTree.append(PlanLeaf(Stream("Salary1", Money(1_000))))
    orTree.append(PlanLeaf(Stream("Salary2", Money(2_000))))
    sut.add(orTree)

    let result = sut.project(3)
    let resultSet = Set([
      result[0].netWorthByMonth.last!.amount,
      result[1].netWorthByMonth.last!.amount,
    ])
    XCTAssertEqual(resultSet, [3_000, 6_000])
  }
}
