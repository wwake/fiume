@testable import fiume

import XCTest

final class SomePossibilities: XCTestCase {
  private func makeStream(_ name: String, _ amount: Int) -> fiume.Stream {
    Stream(name, Money(amount), first: .month(2024.jan), last: .unchanged)
  }

  private func makePossibilities() -> Possibilities {
    Possibilities(startDate: 2030.jan)
  }

	func test_salary_builds_net_worth() throws {
		let sut = makePossibilities()
		sut.add(makeStream("Salary", Money(1_000)))

    let data = sut.netWorth(sut.range(12))

    XCTAssertEqual(data[0].netWorthByMonth.last!.amount, Money(12_000))
	}

	func test_salary_minus_expenses_creates_net_worth() throws {
		let sut = makePossibilities()
		sut.add(makeStream("Salary", Money(1_000)))
		sut.add(makeStream("Expenses", Money(-900)))

		let data = sut.netWorth(sut.range(12))

    XCTAssertEqual(data[0].netWorthByMonth.last!.amount, Money(1_200))
	}

  func test_scenarios_start_with_empty_name() {
    let sut = makePossibilities()
    let scenarios = sut.scenarios()
    scenarios.forEach {
      XCTAssertEqual($0.name, "Scenario")
    }
  }

  func test_scenarios_with_only_groups() {
		let sut = makePossibilities()
		sut.add(makeStream("Salary", Money(1_000)))
		sut.add(makeStream("Expenses", Money(-900)))

    let result = Array(sut.scenarios())

		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result.first!.net(at: 2024.jan), Money(100))
	}

  func test_adds_scenarios() {
    let sut = makePossibilities()

    var orTree = Plan.makeOr("jobs")
    orTree.append(Plan.makeStream(makeStream("Salary1", Money(1_000))))
    orTree.append(Plan.makeStream(makeStream("Salary2", Money(2_000))))
    sut.add(orTree)

    print(sut.plan)

    let result = Array(sut.scenarios())

    XCTAssertEqual(result.count, 2)
  }

  func test_computes_net_worth_for_multiple_scenarios() {
    let sut = makePossibilities()
    var orTree = Plan.makeOr("jobs")
    orTree.append(Plan.makeStream(makeStream("Salary1", Money(1_000))))
    orTree.append(Plan.makeStream(makeStream("Salary2", Money(2_000))))
    sut.add(orTree)

    let result = sut.netWorth(sut.range(3))
    let resultSet = Set([
      result[0].netWorthByMonth.last!.amount,
      result[1].netWorthByMonth.last!.amount,
    ])
    XCTAssertEqual(resultSet, [3_000, 6_000])
  }
}
